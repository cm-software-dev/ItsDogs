//
//  BreedListResponse.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

struct BreedListResponse: Codable {
    let message: [String : [String]]
    let status: String
    
    init(message: [String : [String]], status: String) {
        self.message = message
        self.status = status
    }
}
