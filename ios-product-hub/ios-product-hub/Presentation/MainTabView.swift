//
//  MainTabView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct MainTabView: View {
    let container: AppDIContainer
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        TabView {
            ProductListView(
                viewModel: ProductListViewModel(
                    fetchUseCase: container.fetchProductsUseCase,
                    searchUseCase: container.searchProductsUseCase,
                    favoritesUseCase: container.favoritesUseCase,
                    crudUseCase: container.crudUseCase
                )
            )
            .tabItem {
                Label("products".localized, systemImage: "square.grid.2x2")
            }

            FavoritesView(
                viewModel: FavoritesViewModel(
                    fetchUseCase: container.fetchProductsUseCase,
                    favoritesUseCase: container.favoritesUseCase
                )
            )
            .tabItem {
                Label("favorites".localized, systemImage: "heart")
            }

            SettingsView(
                viewModel: SettingsViewModel(
                    authRepository: container.authRepository
                )
            )
            .tabItem {
                Label("settings".localized, systemImage: "gearshape")
            }
        }
        .environment(
            \.layoutDirection,
            languageManager.isRTL ? .rightToLeft : .leftToRight
        )
    }
}
