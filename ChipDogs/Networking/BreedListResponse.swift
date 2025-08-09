//
//  BreedListResponse.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

struct BreedListResponse: Codable {
    let message: [String : [String]]
    let status: ResponseStatus
    
    init(message: [String : [String]], status: ResponseStatus) {
        self.message = message
        self.status = status
    }
}
