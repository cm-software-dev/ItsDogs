//
//  MockDogImageAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 08/08/2025.
//
@testable import ChipDogs

class MockDogImageAPI: FetchDogImagesAPIProtocol {
    
    var fetchDogImagesWithSubreedCallCounter = 0
    var fetchDogImagesBreedOnlyCallCounter = 0
    
    var imageResponse: ImageResponse = ImageResponse(message: [], status: "test")
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> ChipDogs.ImageResponse {
        fetchDogImagesWithSubreedCallCounter+=1
        return imageResponse
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> ChipDogs.ImageResponse {
        fetchDogImagesBreedOnlyCallCounter += 1
        return imageResponse
    }
    
    
}
