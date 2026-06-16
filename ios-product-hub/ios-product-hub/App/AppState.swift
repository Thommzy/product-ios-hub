//
//  AppState.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false

    private let keychainService: KeychainServiceProtocol
    private let tokenKey = "auth_token"

    init(keychainService: KeychainServiceProtocol = KeychainService()) {
        self.keychainService = keychainService
        self.isLoggedIn = keychainService.get(forKey: tokenKey) != nil
    }

    func logout(keychainService: KeychainServiceProtocol) {
        keychainService.delete(forKey: tokenKey)
        isLoggedIn = false
    }
}
