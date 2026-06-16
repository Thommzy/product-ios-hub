//
//  SettingsViewModel.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func logout(appState: AppState) {
        authRepository.logout()
        appState.isLoggedIn = false
    }
}
