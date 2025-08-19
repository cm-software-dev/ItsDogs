//
//  MockAPIManager.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//
@testable import ItsDogs

class MockAPIManager<T: Decodable>: APIManagerProtocol {
    
    var response: T?
    var getDataCallCounter = 0
    var endpointPassed: ApiEndpoint?
    
    func getData<D: Decodable>(from endpoint: ItsDogs.ApiEndpoint) async throws -> D where D : Decodable {
        getDataCallCounter+=1
        endpointPassed = endpoint
        if let response = response {
            return response as! D
        }
        else {
            throw DogError.fetchError("test. no response")
        }
    }
    
    
}
