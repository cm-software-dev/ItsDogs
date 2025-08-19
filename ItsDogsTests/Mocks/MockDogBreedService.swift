//
//  MockDogAPI.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ItsDogs

class MockDogBreedService: DogBreedServiceProtocol {
    
    
    var breedResponse: [Breed] = []
    var fetchBreedListCallCounter = 0
  
    var throwError = false
    
    func fetchBreedList() async throws -> [Breed] {
        fetchBreedListCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return breedResponse
    }
}
