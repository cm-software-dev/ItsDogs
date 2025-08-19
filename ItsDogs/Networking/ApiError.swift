//
//  ApiError.swift
//  ItsDogs
//
//  Created by Calum Maclellan on 14/08/2025.
//


enum ApiError: Error {
   case invalidPath
   case decoding
}

extension ApiError {
   var localizedDescription: String {
      switch self {
      case .invalidPath:
         return "Invalid Path"
      case .decoding:
         return "There was an error decoding the type"
      }
   }
}
