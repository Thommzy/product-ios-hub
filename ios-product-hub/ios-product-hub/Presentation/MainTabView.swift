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
            .tabItem { Label("Products", systemImage: "square.grid.2x2") }

            FavoritesView(
                viewModel: FavoritesViewModel(
                    fetchUseCase: container.fetchProductsUseCase,
                    favoritesUseCase: container.favoritesUseCase
                )
            )
            .tabItem { Label("Favorites", systemImage: "heart") }

            SettingsView(
                viewModel: SettingsViewModel(authRepository: container.authRepository)
            )
            .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
