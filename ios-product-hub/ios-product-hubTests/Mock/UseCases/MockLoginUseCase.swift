//
//  MockLoginUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockLoginUseCase: LoginUseCase {
    var shouldFail = false

    func execute(username: String, password: String) async throws -> String {
        if shouldFail { throw AuthError.invalidCredentials }
        return "mock_token"
    }
}
