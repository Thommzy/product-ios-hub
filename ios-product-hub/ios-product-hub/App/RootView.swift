//
//  RootView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct RootView: View {
    let container: AppDIContainer
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isLoggedIn {
            MainTabView(container: container)
        } else {
            LoginViewControllerRepresentable(container: container)
                .ignoresSafeArea()
        }
    }
}
