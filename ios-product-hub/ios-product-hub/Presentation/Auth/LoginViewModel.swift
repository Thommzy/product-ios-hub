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

    private var loginTask: Task<Void, Never>? = nil
    private let loginUseCase: LoginUseCase
    private let biometricUseCase: BiometricUseCase
    var canUseBiometrics: Bool { biometricUseCase.canUseBiometrics() }

    init(loginUseCase: LoginUseCase, biometricUseCase: BiometricUseCase) {
        self.loginUseCase = loginUseCase
        self.biometricUseCase = biometricUseCase
    }

    deinit {
        loginTask?.cancel()
    }


    func login() {
        loginTask?.cancel()
        loginTask = Task {
            await MainActor.run { isLoading = true; errorMessage = nil }
            do {
                _ = try await loginUseCase.execute(
                    username: username, password: password
                )
                await MainActor.run { isLoggedIn = true }
            } catch {
                await MainActor.run { errorMessage = error.localizedDescription }
            }
            await MainActor.run { isLoading = false }
        }
    }

    func loginWithBiometrics() {
        loginTask?.cancel()
        loginTask = Task {
            await MainActor.run { isLoading = true }
            do {
                try await biometricUseCase.authenticate()
                await MainActor.run { isLoggedIn = true }
            } catch {
                await MainActor.run { errorMessage = error.localizedDescription }
            }
            await MainActor.run { isLoading = false }
        }
    }
}
