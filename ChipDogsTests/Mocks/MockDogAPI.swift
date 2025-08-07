//
//  MockDogAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs

class MockDogAPI: FetchDogsAPIProtocol {
    
    var breedResponse: BreedListResponse = BreedListResponse(message: [:], status: "test")
    
    var fetchBreedListCallCounter = 0
    
    func fetchBreedList() async throws -> ChipDogs.BreedListResponse {
        fetchBreedListCallCounter += 1
        return breedResponse
    }
    
}
