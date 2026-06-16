//
//  MockFavoritesUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockFavoritesUseCase: FavoritesUseCase {
    var favoriteIds: [Int] = []
    var toggleCalled = false

    func getFavoriteIds() -> [Int] { favoriteIds }
    func toggleFavorite(productId: Int) { toggleCalled = true }
    func isFavorite(productId: Int) -> Bool { favoriteIds.contains(productId) }
}
