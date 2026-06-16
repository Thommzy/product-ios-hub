//
//  NetworkError.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse
    case decodingFailed(Error)
    case noInternet

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .badResponse: return "Server returned an error"
        case .decodingFailed(let e): return "Decoding failed: \(e.localizedDescription)"
        case .noInternet: return "No internet connection"
        }
    }
}
