//
//  BreedDetailViewModel.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
import SwiftUI

class BreedDetailViewModel: BreedDetailViewModelProtocol, ObservableObject {
    
    private let breed: String
    private let subbreed: String?
    private let api: FetchDogImagesAPIProtocol
    private let numberOfImages = 10
    
    @Published var imageURLS: [URL] = []
    
    var title: String {
        get {
            if let subbreed = subbreed {
                return "\(subbreed.capitalized) \(breed)"
            }
            else {
                return breed.capitalized
            }
        }
    }
    
    init(breed: String, subbreed: String? = nil, api: FetchDogImagesAPIProtocol) {
        self.breed = breed
        self.subbreed = subbreed
        self.api = api
    }
    
    private func fetchImages() {
        Task {
            if let subbreed = subbreed {
               try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed, subbreed: subbreed)
            }
            else {
               try await api.fetchDogImages(numberOfImages: numberOfImages, breed: breed)
            }
            
        }
    }
}

protocol BreedDetailViewModelProtocol {
    var title: String {get}
}
