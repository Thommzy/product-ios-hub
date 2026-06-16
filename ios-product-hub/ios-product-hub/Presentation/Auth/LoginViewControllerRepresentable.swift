//
//  LoginViewControllerRepresentable.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    let container: AppDIContainer
    @EnvironmentObject var appState: AppState

    func makeUIViewController(context: Context) -> LoginViewController {
        let vm = LoginViewModel(
            loginUseCase: container.loginUseCase,
            biometricUseCase: container.biometricUseCase
        )
        let vc = LoginViewController(viewModel: vm)
        vc.onLoginSuccess = { appState.isLoggedIn = true }
        return vc
    }

    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {}
}
