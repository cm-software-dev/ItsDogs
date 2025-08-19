//
//  BreedDetailViewModel.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
import SwiftUI

class BreedDetailViewModel: BreedDetailViewModelProtocol, ObservableObject {
    
    private let breed: SelectedBreed
    private let imageService: DogImageServiceProtocol
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
    
    init(breed: SelectedBreed, imageService: DogImageServiceProtocol) {
        self.breed = breed
        self.imageService = imageService
    }
    
    @MainActor
    func fetchImages() async {
        do {
            imageURLs = breed.subbreed != nil ?
            try await imageService.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName, subbreed: breed.subbreed!)
            : try await imageService.fetchDogImages(numberOfImages: numberOfImages, breed: breed.breedName)
        }
        catch DogError.fetchError(let message){
            print("Error in: BreedDetailViewModel.fetchImages failed. \(message)")
            fetchFailed = true
        }
        catch {
            print("Error in: BreedDetailViewModel.fetchImages failed. \(error.localizedDescription)")
        }
    }
}

protocol BreedDetailViewModelProtocol {
    var title: String {get}
    var fetchFailed: Bool {get set}
    func fetchImages() async
}
