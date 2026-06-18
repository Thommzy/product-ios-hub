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
    case httpError(statusCode: Int)
    case decodingFailed(Error)
    case noInternet
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .badResponse: return "Server returned an error"
        case .httpError(let code): return "Server error with status code \(code)"
        case .decodingFailed(let e): return "Decoding failed: \(e.localizedDescription)"
        case .noInternet: return "No internet connection"
        case .timeout: return "Request timed out. Please try again"
        case .unknown(let e): return "Something went wrong: \(e.localizedDescription)"
        }
    }
}
