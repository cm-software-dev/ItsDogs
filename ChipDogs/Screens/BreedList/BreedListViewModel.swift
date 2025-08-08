//
//  BreedListViewModel.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import SwiftUI
import Foundation

class BreedListViewModel: BreedListViewModelProtocol, ObservableObject {
    
    @Published var breedList: [Breed]
    
    private let dogAPI: FetchDogsAPIProtocol
    
    var title = "Dog Breeds"
    
    init(dogAPI: FetchDogsAPIProtocol) {
        self.breedList = []
        self.dogAPI = dogAPI
    }
    
    func fetchBreeds() {
        Task
        {
            let newBreedList = try await dogAPI.fetchBreedList().message
                    .map({Breed(breedName: $0, subbreeds: $1)})
                        .sorted(by: {$0.breedName < $1.breedName})
                    await MainActor.run {
                        [weak self] in
                        self?.breedList = newBreedList
                    }
                }
        }
    }

  
    protocol BreedListViewModelProtocol {
        var breedList: [Breed] {get}
        var title: String {get}
        func fetchBreeds()
    }
