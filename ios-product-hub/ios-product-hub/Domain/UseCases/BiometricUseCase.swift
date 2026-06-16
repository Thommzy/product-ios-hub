//
//  BiometricUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import LocalAuthentication

protocol BiometricUseCase {
    func canUseBiometrics() -> Bool
    func authenticate() async throws
}

final class BiometricUseCaseImpl: BiometricUseCase {
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }

    func authenticate() async throws {
        let context = LAContext()
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Log in to ProductHub"
            )
            if !success { throw AuthError.biometricFailed }
        } catch {
            throw AuthError.biometricFailed
        }
    }
}
