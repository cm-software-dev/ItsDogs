//
//  DogImageService.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import Foundation

struct DogImageService: DogImageServiceProtocol {
    
    private let api: APIManagerProtocol
    
    init(api: APIManagerProtocol) {
        self.api = api
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [URL] {
        do {
            let response: ImageResponse = try await api.getData(from: .fetchDogImagesWithSubbreed(breed: breed, subbreed: subbreed, numberOfImages: 10))
            guard response.status == .success else {
                throw DogError.fetchError("Failed to fetch dog images!")
            }
            return response.message.compactMap({URL(string: $0)})
        }
        catch {
            print("Error in DogBreedService.fetchDogImagesWithSubbreed \(error.localizedDescription)")
            throw DogError.fetchError("Error fetching dog images!")
        }
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [URL] {
        do {
            let response: ImageResponse = try await api.getData(from: .fetchDogImages(breed: breed, numberOfImages: 10))
            guard response.status == .success else {
                throw DogError.fetchError("Failed to fetch dog images!")
            }
            return response.message.compactMap({URL(string: $0)})
        }
        catch {
            print("Error in DogBreedService.fetchDogImages \(error.localizedDescription)")
            throw DogError.fetchError("Error fetching dog images!")
        }
    }
    
    func fetchSingleRandomDogImage() async throws -> URL {
        do {
            let response: SingleImageResponse = try await api.getData(from: .fetchSingleRandomDogImage)
            guard response.status == .success, let url = URL(string: response.message) else {
                throw DogError.fetchError("Failed to fetch dog image!")
            }
            return url
        }
        catch {
            print("Error in DogBreedService.fetchBreedList \(error.localizedDescription)")
            throw DogError.fetchError("Error fetching dog image!")
        }
    }
    
    
}


protocol DogImageServiceProtocol {
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [URL]
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [URL]
    func fetchSingleRandomDogImage() async throws -> URL
}
