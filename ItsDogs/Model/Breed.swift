//
//  Breed.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

struct Breed: Hashable {
    let breedName: String
    let subbreeds: [String]
}


struct SelectedBreed {
    let breedName: String
    let subbreed: String?
    
    var displayName: String {
        if let sub = subbreed {
            return "\(sub.capitalized) \(breedName)"
        }
        else {
            return breedName.capitalized
        }
    }
}
