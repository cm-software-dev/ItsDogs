//
//  ImageResponse.swift
//  ChipDogs
//
//  Created by Calum Maclellan on 07/08/2025.
//

import Foundation

struct ImageResponse: Codable {
    let message: [String]
    let status: ResponseStatus
}


enum ResponseStatus: String, Codable {
    case success = "success"
    case error = "error"
}
