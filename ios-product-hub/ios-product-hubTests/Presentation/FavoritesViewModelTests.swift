//
//  FavoritesViewModelTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class FavoritesViewModelTests: XCTestCase {
    var sut: FavoritesViewModel!
    var mockFetch: MockFetchProductsUseCase!
    var mockFavorites: MockFavoritesUseCase!

    override func setUp() {
        mockFetch = MockFetchProductsUseCase()
        mockFavorites = MockFavoritesUseCase()
        sut = FavoritesViewModel(
            fetchUseCase: mockFetch,
            favoritesUseCase: mockFavorites
        )
    }

    func test_load_showsOnlyFavoriteProducts() async {
        let p1 = Product.mock(id: 1)
        let p2 = Product.mock(id: 2)
        mockFetch.mockResponse = ProductResponse(
            products: [p1, p2], total: 2, skip: 0, limit: 20
        )
        mockFavorites.favoriteIds = [1]
        await sut.load()
        XCTAssertEqual(sut.favoriteProducts.count, 1)
        XCTAssertEqual(sut.favoriteProducts.first?.id, 1)
    }

    func test_remove_product_updatesListAndSetsRecentlyRemoved() async {
        let product = Product.mock(id: 1)
        mockFetch.mockResponse = ProductResponse(
            products: [product], total: 1, skip: 0, limit: 20
        )
        mockFavorites.favoriteIds = [1]
        await sut.load()
        sut.remove(product: product)
        XCTAssertTrue(sut.favoriteProducts.isEmpty)
        XCTAssertNotNil(sut.recentlyRemoved)
    }

    func test_undoRemove_restoresProduct() async {
        let product = Product.mock(id: 1)
        mockFetch.mockResponse = ProductResponse(
            products: [product], total: 1, skip: 0, limit: 20
        )
        mockFavorites.favoriteIds = [1]
        await sut.load()
        sut.remove(product: product)
        sut.undoRemove()
        XCTAssertEqual(sut.favoriteProducts.count, 1)
        XCTAssertNil(sut.recentlyRemoved)
    }

    func test_load_setsEmptyListWhenNoFavorites() async {
        mockFetch.mockResponse = ProductResponse(
            products: [Product.mock(id: 1)], total: 1, skip: 0, limit: 20
        )
        mockFavorites.favoriteIds = []
        await sut.load()
        XCTAssertTrue(sut.favoriteProducts.isEmpty)
    }
}
