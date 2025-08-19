//
//  APIManager.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
import Foundation

final class APIManager: APIManagerProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://dog.ceo"
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
   
    
    static let shared = APIManager()
    
    func getData<D: Decodable>(from endpoint: ApiEndpoint) async throws -> D {
        let request = try createRequest(from: endpoint)
        let response = try await session.data(for: request)
        return try decoder.decode(D.self, from: response.0)
    }
    
    private func createRequest(from endpoint: ApiEndpoint) throws -> URLRequest {
        guard
            let urlPath = URL(string: baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path)
        else {
            throw ApiError.invalidPath
        }
        
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


protocol APIManagerProtocol {
    func getData<D: Decodable>(from endpoint: ApiEndpoint) async throws -> D
}
