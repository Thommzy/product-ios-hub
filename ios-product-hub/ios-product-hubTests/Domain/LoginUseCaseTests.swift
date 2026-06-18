//
//  LoginUseCaseTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

final class LoginUseCaseTests: XCTestCase {
    var sut: LoginUseCaseImpl!
    var mockRepo: MockAuthRepository!

    override func setUp() {
        mockRepo = MockAuthRepository()
        sut = LoginUseCaseImpl(repository: mockRepo)
    }

    func test_emptyUsername_throwsEmptyFields() async {
        do {
            _ = try await sut.execute(username: "", password: "password")
            XCTFail("Expected error")
        } catch AuthError.emptyFields {
            // pass
        } catch { XCTFail("Wrong error: \(error)") }
    }

    func test_emptyPassword_throwsEmptyFields() async {
        do {
            _ = try await sut.execute(username: "emilys", password: "")
            XCTFail("Expected error")
        } catch AuthError.emptyFields {
            // pass
        } catch { XCTFail("Wrong error: \(error)") }
    }

    func test_shortUsername_throwsUsernameTooShort() async {
        do {
            _ = try await sut.execute(username: "ab", password: "password")
            XCTFail("Expected error")
        } catch AuthError.usernameTooShort {
            // pass
        } catch { XCTFail("Wrong error: \(error)") }
    }

    func test_shortPassword_throwsPasswordTooShort() async {
        do {
            _ = try await sut.execute(username: "emilys", password: "123")
            XCTFail("Expected error")
        } catch AuthError.passwordTooShort {
            // pass
        } catch { XCTFail("Wrong error: \(error)") }
    }

    func test_validCredentials_returnsToken() async throws {
        mockRepo.mockToken = "test_token"
        let token = try await sut.execute(
            username: "emilys",
            password: "emilyspass"
        )
        XCTAssertEqual(token, "test_token")
    }

    func test_whitespaceCredentials_throwsEmptyFields() async {
        do {
            _ = try await sut.execute(username: "   ", password: "   ")
            XCTFail("Expected error")
        } catch AuthError.emptyFields {
            // pass
        } catch { XCTFail("Wrong error: \(error)") }
    }
}
