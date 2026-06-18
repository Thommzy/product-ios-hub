//
//  AuthError.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

enum AuthError: LocalizedError {
    case emptyFields
    case usernameTooShort
    case passwordTooShort
    case invalidCredentials
    case biometricFailed

    var errorDescription: String? {
        switch self {
        case .emptyFields: return "Username and password are required"
        case .usernameTooShort: return "Username must be at least 3 characters"
        case .passwordTooShort: return "Password must be at least 6 characters"
        case .invalidCredentials: return "Invalid username or password"
        case .biometricFailed: return "Biometric authentication failed"
        }
    }
}
