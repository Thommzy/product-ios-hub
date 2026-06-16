//
//  ios_product_hubApp.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

@main
struct ios_product_hubApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var languageManager = LanguageManager.shared
    private let container = AppDIContainer()

    var body: some Scene {
        WindowGroup {
            RootView(container: container)
                .environmentObject(appState)
                .environmentObject(languageManager)
        }
    }
}
