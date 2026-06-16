//
//  FavoritesView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var viewModel: FavoritesViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.favoriteProducts.isEmpty {
                    ContentUnavailableView(
                        "no_favorites".localized,
                        systemImage: "heart.slash",
                        description: Text("add_products_to_favorites".localized)
                    )
                } else {
                    List {
                        ForEach(viewModel.favoriteProducts) { product in
                            ProductRowView(
                                product: product,
                                isFavorite: true
                            ) {
                                viewModel.remove(product: product)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.remove(product: product)
                                } label: {
                                    Label("remove".localized, systemImage: "heart.slash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("favorites".localized)
            .task { await viewModel.load() }
            .overlay(alignment: .bottom) {
                if viewModel.recentlyRemoved != nil {
                    UndoToastView { viewModel.undoRemove() }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding()
                }
            }
            .animation(.easeInOut, value: viewModel.recentlyRemoved != nil)
        }
    }
}
