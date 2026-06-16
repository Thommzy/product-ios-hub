//
//  FavoritesUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol FavoritesUseCase {
    func getFavoriteIds() -> [Int]
    func toggleFavorite(productId: Int)
    func isFavorite(productId: Int) -> Bool
}

final class FavoritesUseCaseImpl: FavoritesUseCase {
    private let repository: FavoritesRepositoryProtocol
    init(repository: FavoritesRepositoryProtocol) { self.repository = repository }
    func getFavoriteIds() -> [Int] { repository.getFavoriteIds() }
    func toggleFavorite(productId: Int) {
        if repository.isFavorite(productId: productId) {
            repository.removeFavorite(productId: productId)
        } else {
            repository.addFavorite(productId: productId)
        }
    }
    func isFavorite(productId: Int) -> Bool { repository.isFavorite(productId: productId) }
}
