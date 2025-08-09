//
//  MockDogAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//
@testable import ChipDogs

class MockDogAPI: DogsAPIProtocol {
    
    
    var breedResponse: BreedListResponse = BreedListResponse(message: [:], status: "test")
    
    var fetchDogImagesWithSubreedCallCounter = 0
    var fetchDogImagesBreedOnlyCallCounter = 0
    
    var imageResponse: ImageResponse = ImageResponse(message: [], status: "test")
    var singleImageResponse: SingleImageResponse = SingleImageResponse(message: "test", status: "test")
    
    var fetchBreedListCallCounter = 0
    var fetchSingleRandomDogImageCallCounter = 0
    
    func fetchBreedList() async throws -> ChipDogs.BreedListResponse {
        fetchBreedListCallCounter += 1
        return breedResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> ChipDogs.ImageResponse {
        fetchDogImagesWithSubreedCallCounter+=1
        return imageResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> ChipDogs.ImageResponse {
        fetchDogImagesBreedOnlyCallCounter += 1
        return imageResponse
    }
    
    func fetchSingleRandomDogImage() async throws -> ChipDogs.SingleImageResponse {
        fetchSingleRandomDogImageCallCounter += 1
        return singleImageResponse
    }
}
