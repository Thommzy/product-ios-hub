//
//  FavoritesViewModel.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteProducts: [Product] = []
    @Published var isLoading: Bool = false
    @Published var recentlyRemoved: (product: Product, index: Int)? = nil

    private let fetchUseCase: FetchProductsUseCase
    private let favoritesUseCase: FavoritesUseCase

    init(fetchUseCase: FetchProductsUseCase, favoritesUseCase: FavoritesUseCase) {
        self.fetchUseCase = fetchUseCase
        self.favoritesUseCase = favoritesUseCase
    }

    func load() async {
        isLoading = true
        let ids = favoritesUseCase.getFavoriteIds()
        do {
            let response = try await fetchUseCase.execute(limit: 100, skip: 0)
            favoriteProducts = response.products.filter { ids.contains($0.id) }
        } catch {}
        isLoading = false
    }

    func remove(product: Product) {
        guard let idx = favoriteProducts.firstIndex(of: product) else { return }
        recentlyRemoved = (product, idx)
        favoritesUseCase.toggleFavorite(productId: product.id)
        favoriteProducts.remove(at: idx)
    }

    func undoRemove() {
        guard let recent = recentlyRemoved else { return }
        favoritesUseCase.toggleFavorite(productId: recent.product.id)
        favoriteProducts.insert(recent.product, at: min(recent.index, favoriteProducts.count))
        recentlyRemoved = nil
    }
}
