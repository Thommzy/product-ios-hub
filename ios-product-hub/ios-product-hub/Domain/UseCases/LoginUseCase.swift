//
//  LoginUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol LoginUseCase {
    func execute(username: String, password: String) async throws -> String
}

final class LoginUseCaseImpl: LoginUseCase {
    private let repository: AuthRepositoryProtocol
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    func execute(username: String, password: String) async throws -> String {
        guard !username.isEmpty, !password.isEmpty else { throw AuthError.emptyFields }
        guard password.count >= 4 else { throw AuthError.passwordTooShort }
        return try await repository.login(username: username, password: password)
    }
}
