//
//  LoginViewModel.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn: Bool = false

    private let loginUseCase: LoginUseCase
    private let biometricUseCase: BiometricUseCase
    var canUseBiometrics: Bool { biometricUseCase.canUseBiometrics() }

    init(loginUseCase: LoginUseCase, biometricUseCase: BiometricUseCase) {
        self.loginUseCase = loginUseCase
        self.biometricUseCase = biometricUseCase
    }

    func login() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                _ = try await loginUseCase.execute(username: username, password: password)
                isLoggedIn = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func loginWithBiometrics() {
        Task {
            isLoading = true
            do {
                try await biometricUseCase.authenticate()
                isLoggedIn = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
