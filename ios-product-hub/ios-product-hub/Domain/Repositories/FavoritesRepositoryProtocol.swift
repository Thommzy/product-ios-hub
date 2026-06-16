//
//  FavoritesRepositoryProtocol.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol FavoritesRepositoryProtocol {
    func getFavoriteIds() -> [Int]
    func addFavorite(productId: Int)
    func removeFavorite(productId: Int)
    func isFavorite(productId: Int) -> Bool
}
