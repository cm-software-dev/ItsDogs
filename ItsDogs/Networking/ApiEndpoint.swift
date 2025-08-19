//
//  ApiEndpoint.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//

import Foundation

enum ApiEndpoint {
    case fetchBreeds
    case fetchDogImages(breed: String, numberOfImages: Int)
    case fetchDogImagesWithSubbreed(breed: String, subbreed: String, numberOfImages: Int)
    case fetchSingleRandomDogImage
}

extension ApiEndpoint {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    var path: String {
        switch self {
        case .fetchBreeds:
            return "/api/breeds/list/all"
        case .fetchDogImages(let breed, let numberOfImages):
            return "/api/breed/\(breed)/images/random/\(numberOfImages)"
        case .fetchDogImagesWithSubbreed(let breed, let subbreed, let numberOfImages):
            return "/api/breed/\(breed)/\(subbreed)/images/random/\(numberOfImages)"
        case .fetchSingleRandomDogImage:
            return "/api/breeds/image/random"
        }
    }
    
    var method: ApiEndpoint.Method {
          switch self {
          default:
             return .GET
          }
       }
    
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
}
