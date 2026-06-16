//
//  AuthRepository.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

final class AuthRepository: AuthRepositoryProtocol {
    private let keychainService: KeychainServiceProtocol
    private let tokenKey = "auth_token"
    private let validUsername = "emilys"
    private let validPassword = "emilyspass"

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    func login(username: String, password: String) async throws -> String {
        try await Task.sleep(nanoseconds: 800_000_000)
        guard username == validUsername, password == validPassword else {
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
