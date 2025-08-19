//
//  MockDogBreedService.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
@testable import ItsDogs
import Foundation

class MockDogImageService: DogImageServiceProtocol {

    var fetchDogImagesWithSubreedCallCounter = 0
    var fetchDogImagesBreedOnlyCallCounter = 0
    
    var imageResponse: [URL] = []
    var singleImageResponse = URL(string: "test")!
    
    var fetchSingleRandomDogImageCallCounter = 0
    
    var throwError = false
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [URL] {
        fetchDogImagesWithSubreedCallCounter+=1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return imageResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [URL] {
        fetchDogImagesBreedOnlyCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return imageResponse
    }
    
    func fetchSingleRandomDogImage() async throws -> URL {
        fetchSingleRandomDogImageCallCounter += 1
        if throwError {
            throw DogError.fetchError("Test error")
        }
        return singleImageResponse
    }
    
    
}
