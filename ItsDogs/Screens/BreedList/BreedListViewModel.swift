//
//  BreedListViewModel.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Foundation
import Combine

class BreedListViewModel: BreedListViewModelProtocol, ObservableObject {
    
    @Published var breedList: [Breed] = []
    @Published var fetchFailed = false
    
    private var fullList: [Breed] = [] {
        didSet {
            breedList = fullList
        }
    }
    
    private let imageService: DogImageServiceProtocol
    private let breedService: DogBreedServiceProtocol
    
    var title = "Dog Breeds"
    
    @Published var welcomeImageURL: URL?
    
    init(imageService: DogImageServiceProtocol, breedService: DogBreedServiceProtocol) {
        self.breedList = []
        self.imageService = imageService
        self.breedService = breedService
    }
    
    @MainActor
    func filterBreeds(term: String) async {
        if term.isEmpty {
            breedList = fullList
        } else {
            breedList = fullList.filter({$0.breedName.contains(term.lowercased())})
        }
    }
    
    @MainActor
    func fetchWelcomeImage() async {
        do {
            let url = try await imageService.fetchSingleRandomDogImage()
            welcomeImageURL = url
        }
        catch DogError.fetchError(let message){
            print("fetchError in: BreedListViewModel.fetchWelcomeImage \(message)")
            fetchFailed = true
        }
        catch {
            print("Error in: BreedListViewModel.fetchWelcomeImage \(error.localizedDescription)")
        }
    }
   
    
    @MainActor
    func fetchBreeds() async {
        do {
            let breeds = try await breedService.fetchBreedList()
            fullList = breeds
        }
        catch DogError.fetchError(let message) {
            print("DogError in: BreedListViewModel.fetchBreeds \(message)")
            fetchFailed = true
        }
        catch {
            print("Error in: BreedListViewModel.fetchBreeds \(error.localizedDescription)")
        }
    }
}

protocol BreedListViewModelProtocol {
    var breedList: [Breed] {get}
    var title: String {get}
    var welcomeImageURL: URL? {get}
    
    func fetchBreeds() async
    func filterBreeds(term: String) async
}
