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
    
    var title: String {
        get {
            if let subbreed = breed.subbreed {
                return "\(subbreed.capitalized) \(breed.breedName)"
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
            let result = breed.subbreed != nil ?
            try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName, subbreed: breed.subbreed!).message
            : try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName).message
            print(result)
            await MainActor.run {
                [weak self] in
                print("Have the imagesuRLs \(result.count)")
                self?.imageURLs = result.compactMap({URL(string: $0)})
                
            }
        }
    }
}

protocol BreedDetailViewModelProtocol {
    var title: String {get}
    func fetchImages()
}
