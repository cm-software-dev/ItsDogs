//
//  MockDogAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs

class MockDogAPI: DogsAPIProtocol {
    
    
    var breedResponse: [String: [String]] = [:]
    var fetchDogImagesWithSubreedCallCounter = 0
    var fetchDogImagesBreedOnlyCallCounter = 0
    
    var imageResponse: [String] = []
    var singleImageResponse = "test"
    
    var fetchBreedListCallCounter = 0
    var fetchSingleRandomDogImageCallCounter = 0
    
    var throwError = false
    
    func fetchBreedList() async throws -> [String: [String]] {
        fetchBreedListCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return breedResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [String] {
        fetchDogImagesWithSubreedCallCounter+=1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return imageResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [String] {
        fetchDogImagesBreedOnlyCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return imageResponse
    }
    
    func fetchSingleRandomDogImage() async throws -> String {
        fetchSingleRandomDogImageCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return singleImageResponse
    }
}
