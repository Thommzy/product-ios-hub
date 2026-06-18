//
//  LoginUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

protocol LoginUseCase {
    func execute(username: String, password: String) async throws -> String
}

final class LoginUseCaseImpl: LoginUseCase {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(username: String, password: String) async throws -> String {
        let trimmedUsername = username.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)

        guard !trimmedUsername.isEmpty, !trimmedPassword.isEmpty else {
            throw AuthError.emptyFields
        }
        guard trimmedUsername.count >= 3 else {
            throw AuthError.usernameTooShort
        }
        guard trimmedPassword.count >= 6 else {
            throw AuthError.passwordTooShort
        }
        return try await repository.login(
            username: trimmedUsername,
            password: trimmedPassword
        )
    }
}
