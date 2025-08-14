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
    @Published var searchTerm: String = ""
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
        
        $searchTerm
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink(receiveValue: {
                [weak self] term in
                if let self = self {
                    if term.isEmpty {
                        self.breedList = self.fullList
                    } else {
                        self.breedList = self.fullList.filter({$0.breedName.contains(term.lowercased())})
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchWelcomeImage() async {
        do {
            let urlString =   try await dogAPI.fetchSingleRandomDogImage()
            try Task.checkCancellation()
            let url = URL(string: urlString)
            welcomeImageURL = url
        }
        catch {
            print("Error in: BreedListViewModel.fetchWelcomeImage \(error.localizedDescription)")
            fetchFailed = true
        }
    }
    
    @MainActor
    func fetchBreeds() async {
        do {
            let breedDict = try await dogAPI.fetchBreedList()
            try Task.checkCancellation()
            let newBreedList = breedDict
                .map({Breed(breedName: $0, subbreeds: $1)})
                .sorted(by: {$0.breedName < $1.breedName})
            
            fullList = newBreedList
        }
        catch {
            print("Error in: BreedListViewModel.fetchBreeds \(error.localizedDescription)")
            fetchFailed = true
        }
    }
}

protocol BreedListViewModelProtocol {
    var breedList: [Breed] {get}
    var title: String {get}
    var searchTerm: String {get set}
    var welcomeImageURL: URL? {get}
    func fetchBreeds() async
}
