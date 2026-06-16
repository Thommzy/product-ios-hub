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
        sut.username = "emilys"
        sut.password = "emilyspass"
        await sut.login()
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }

    func test_login_failure_setsError() async {
        mockLogin.shouldFail = true
        sut.username = "wrong"
        sut.password = "wrong"
        await sut.login()
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNotNil(sut.errorMessage)
    }
}
