//
//  BreedListViewModel.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Foundation
import Combine

class BreedListViewModel: BreedListViewModelProtocol, ObservableObject {
    
    @Published var breedList: [Breed] = []
    @Published var fetchFailed = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private var fullList: [Breed] = [] {
        didSet {
            breedList = fullList
        }
    }
    
    private let dogAPI: DogsAPIProtocol
    
    var title = "Dog Breeds"
    
    @Published var welcomeImageURL: URL?
    
    init(dogAPI: DogsAPIProtocol) {
        self.breedList = []
        self.dogAPI = dogAPI
    }
    
    @MainActor
    func filterBreeds(term: String)  {
        if term.isEmpty {
            breedList = fullList
        } else {
            breedList = fullList.filter({$0.breedName.contains(term.lowercased())})
        }
    }
    
    @MainActor
    func fetchWelcomeImage() async {
        do {
            let urlString =   try await dogAPI.fetchSingleRandomDogImage()
            //try Task.checkCancellation()
            let url = URL(string: urlString)
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
            let breedDict = try await dogAPI.fetchBreedList()
            let newBreedList = breedDict
                .map({Breed(breedName: $0, subbreeds: $1)})
                .sorted(by: {$0.breedName < $1.breedName})
            
            fullList = newBreedList
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
    func filterBreeds(term: String)
}
