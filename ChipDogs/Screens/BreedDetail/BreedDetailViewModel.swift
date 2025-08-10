//
//  BreedDetailViewModel.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
import SwiftUI

class BreedDetailViewModel: BreedDetailViewModelProtocol, ObservableObject {
    
    private let breed: SelectedBreed
    private let api: FetchDogImagesAPIProtocol
    private let numberOfImages = 10
    
    @Published var imageURLs: [URL] = []
    @Published var fetchFailed = false
    
    var title: String {
        get {
            if let subbreed = breed.subbreed {
                return "\(subbreed.capitalized) \(breed.breedName.capitalized)"
            }
            else {
                return breed.breedName.capitalized
            }
        }
    }
    
    init(breed: SelectedBreed, api: FetchDogImagesAPIProtocol) {
        self.breed = breed
        self.api = api
    }
    
    func fetchImages() {
        Task {
            do {
                let result = breed.subbreed != nil ?
                try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName, subbreed: breed.subbreed!)
                : try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName)
                print(result)
                await MainActor.run {
                    [weak self] in
                    self?.imageURLs = result.compactMap({URL(string: $0)})
                    
                }
            }
            catch {
                print("Error in: BreedDetailViewModel.fetchImages failed. \(error.localizedDescription)")
                await MainActor.run {
                    [weak self] in
                    self?.fetchFailed = true
                }
            }
        }
    }
}

protocol BreedDetailViewModelProtocol {
    var title: String {get}
    var fetchFailed: Bool {get set}
    func fetchImages()
}
