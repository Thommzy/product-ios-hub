//
//  FavoritesRepository.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

final class FavoritesRepository: FavoritesRepositoryProtocol {
    private let local: FavoritesLocalDataSource
    init(local: FavoritesLocalDataSource) { self.local = local }

    func getFavoriteIds() -> [Int] { local.fetchAll() }
    func addFavorite(productId: Int) { local.add(productId: productId) }
    func removeFavorite(productId: Int) { local.remove(productId: productId) }
    func isFavorite(productId: Int) -> Bool { local.contains(productId: productId) }
}
