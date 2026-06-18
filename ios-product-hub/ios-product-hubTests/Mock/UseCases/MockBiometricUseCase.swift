//
//  MockBiometricUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockBiometricUseCase: BiometricUseCase {
    func canUseBiometrics() -> Bool { false }
    func authenticate() async throws {}
}
