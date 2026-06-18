//
//  AuthRepository.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

// Credentials are validated locally for demo purposes.
// In production this would call a real auth endpoint over HTTPS.

final class AuthRepository: AuthRepositoryProtocol {
    private let keychainService: KeychainServiceProtocol
    private let tokenKey = "auth_token"

    private enum Credentials {
        static let username = "timothy"
        static let password = "pass123word"
    }

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func login(username: String, password: String) async throws -> String {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard username == Credentials.username,
              password == Credentials.password else {
            throw AuthError.invalidCredentials
        }
        let token = "token_\(UUID().uuidString)"
        keychainService.save(token, forKey: tokenKey)
        return token
    }

    func logout() { keychainService.delete(forKey: tokenKey) }
    func getStoredToken() -> String? { keychainService.get(forKey: tokenKey) }
    func isLoggedIn() -> Bool { getStoredToken() != nil }
}
