//
//  DogAPI.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import Foundation

struct DogAPI: Sendable, DogsAPIProtocol {
    
    private let baseURL: URL = URL(string: "https://dog.ceo")!
    private let urlSession: URLSession = .shared
    
    
    func fetchBreedList() async throws -> [String: [String]] {
        let url = baseURL.appendingPathComponent("api/breeds/list/all")
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        let response =  try decoder.decode(BreedListResponse.self, from: data)
        guard response.status == .success else {
            throw DogError.fetchError("Failed to fetch dog images")
        }
        return response.message
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [String] {
        let url = baseURL.appendingPathComponent("api/breed/\(breed)/\(subbreed)/images/random/\(numberOfImages)")
        return try await fetchDogImages(forURL: url)
    }
    
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [String] {
        let url = baseURL.appendingPathComponent("api/breed/\(breed)/images/random/\(numberOfImages)")
        return try await fetchDogImages(forURL: url)
    }
    
    private func fetchDogImages(forURL url: URL) async throws -> [String] {
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        let response =  try decoder.decode(ImageResponse.self, from: data)
        guard response.status != .success else {
            throw DogError.fetchError("Failed to fetch dog images")
        }
        return response.message
    }
    
    func fetchSingleRandomDogImage() async throws -> String  {
        let url = baseURL.appendingPathComponent("api/breeds/image/random")
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        let response =  try decoder.decode(SingleImageResponse.self, from: data)
        guard response.status == .success else {
            throw DogError.fetchError("Failed to fetch dog images")
        }
        return response.message
    }
}

protocol DogsAPIProtocol: FetchDogsAPIProtocol, FetchDogImagesAPIProtocol {
    
}

protocol FetchDogsAPIProtocol {
    func fetchBreedList() async throws -> [String: [String]]
}

protocol FetchDogImagesAPIProtocol {
    func fetchDogImages(numberOfImages: Int, breed: String, subbreed: String) async throws -> [String]
    func fetchDogImages(numberOfImages: Int, breed: String) async throws -> [String]
    func fetchSingleRandomDogImage() async throws -> String
}
