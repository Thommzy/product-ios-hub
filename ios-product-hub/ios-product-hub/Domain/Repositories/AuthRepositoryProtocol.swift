//
//  AuthRepositoryProtocol.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> String
    func logout()
    func getStoredToken() -> String?
    func isLoggedIn() -> Bool
}
