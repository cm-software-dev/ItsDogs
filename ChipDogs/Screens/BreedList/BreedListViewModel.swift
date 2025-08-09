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
    
    func fetchWelcomeImage() {
        Task {
            [weak self] in
            do {
                if let response = try await self?.dogAPI.fetchSingleRandomDogImage(), let url = URL(string: response) {
                    await MainActor.run {
                        [weak self] in
                        self?.welcomeImageURL = url
                    }
                }
            }
            catch {
                print("Error in: BreedListViewModel.fetchWelcomeImage \(error.localizedDescription)")
                await MainActor.run
                {
                    [weak self] in
                    self?.fetchFailed = true
                }
            }
            
        }
    }
    
    func fetchBreeds() {
        Task
        {
            do {
                let newBreedList = try await dogAPI.fetchBreedList()
                    .map({Breed(breedName: $0, subbreeds: $1)})
                    .sorted(by: {$0.breedName < $1.breedName})
                await MainActor.run {
                    [weak self] in
                    self?.fullList = newBreedList
                }
            }
            catch {
                print("Error in: BreedListViewModel.fetchBreeds \(error.localizedDescription)")
                await MainActor.run
                {
                    [weak self] in
                    self?.fetchFailed = true
                }
            }
        }
    }
}

protocol BreedListViewModelProtocol {
    var breedList: [Breed] {get}
    var title: String {get}
    var searchTerm: String {get set}
    var welcomeImageURL: URL? {get}
    func fetchBreeds()
}
