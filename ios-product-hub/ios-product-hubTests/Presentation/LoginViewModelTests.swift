//
//  LoginViewModelTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var mockLogin: MockLoginUseCase!
    var mockBiometric: MockBiometricUseCase!

    override func setUp() {
        mockLogin = MockLoginUseCase()
        mockBiometric = MockBiometricUseCase()
        sut = LoginViewModel(loginUseCase: mockLogin, biometricUseCase: mockBiometric)
    }

    func test_login_success() async {
        sut.username = "timothy"
        sut.password = "pass123word"
        sut.login()
        
        // Wait for the async task to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }

    func test_login_failure_setsError() async {
        mockLogin.shouldFail = true
        sut.username = "wrong"
        sut.password = "wrong"
        sut.login()
        
        // Wait for the async task to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNotNil(sut.errorMessage)
    }
}
