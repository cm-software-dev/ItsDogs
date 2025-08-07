//
//  DogAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import Foundation

struct DogAPI: Sendable, FetchDogsAPIProtocol, FetchDogImagesAPIProtocol {
    
    private let baseURL: URL = URL(string: "https://dog.ceo")!
    private let urlSession: URLSession = .shared
    
    
    func fetchBreedList() async throws -> BreedListResponse {
        let url = baseURL.appendingPathComponent("api/breeds/list/all")
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(BreedListResponse.self, from: data)
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> ImageResponse {
        let url = baseURL.appendingPathComponent("api/breed/\(breed)/\(subbreed)/images/random/\(numberOfImages)")
        return try await fetchDogImages(forURL: url)
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> ImageResponse {
        let url = baseURL.appendingPathComponent("api/breed/\(breed)/images/random/\(numberOfImages)")
        return try await fetchDogImages(forURL: url)
    }
    
    private func fetchDogImages(forURL url: URL) async throws -> ImageResponse {
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(ImageResponse.self, from: data)
    }
}


protocol FetchDogsAPIProtocol {
    func fetchBreedList() async throws -> BreedListResponse
}

protocol FetchDogImagesAPIProtocol {
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> ImageResponse
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> ImageResponse
}
