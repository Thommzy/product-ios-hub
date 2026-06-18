//
//  MockAuthRepository.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

@testable import ios_product_hub

final class MockAuthRepository: AuthRepositoryProtocol {
    var mockToken: String = "mock_token"
    var shouldFail = false
    var logoutCalled = false

    func login(username: String, password: String) async throws -> String {
        if shouldFail { throw AuthError.invalidCredentials }
        return mockToken
    }

    func logout() { logoutCalled = true }
    func getStoredToken() -> String? { shouldFail ? nil : mockToken }
    func isLoggedIn() -> Bool { !shouldFail }
}
