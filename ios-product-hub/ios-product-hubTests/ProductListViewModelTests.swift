//
//  ProductListViewModelTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class ProductListViewModelTests: XCTestCase {
    var sut: ProductListViewModel!
    var mockFetch: MockFetchProductsUseCase!
    var mockSearch: MockSearchProductsUseCase!
    var mockFavorites: MockFavoritesUseCase!
    var mockCRUD: MockCRUDUseCase!

    override func setUp() {
        mockFetch = MockFetchProductsUseCase()
        mockSearch = MockSearchProductsUseCase()
        mockFavorites = MockFavoritesUseCase()
        mockCRUD = MockCRUDUseCase()
        sut = ProductListViewModel(
            fetchUseCase: mockFetch,
            searchUseCase: mockSearch,
            favoritesUseCase: mockFavorites,
            crudUseCase: mockCRUD
        )
    }

    func test_loadInitial_populatesProducts() async {
        mockFetch.mockResponse = ProductResponse(
            products: [.mock()], total: 1, skip: 0, limit: 20
        )
        await sut.loadInitial()
        XCTAssertEqual(sut.products.count, 1)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadInitial_setsErrorOnFailure() async {
        mockFetch.shouldFail = true
        await sut.loadInitial()
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.products.isEmpty)
    }

    func test_toggleFavorite() {
        let product = Product.mock()
        mockFavorites.favoriteIds = []
        sut.toggleFavorite(product: product)
        XCTAssertTrue(mockFavorites.toggleCalled)
    }

    func test_deleteProduct_removesFromList() async {
        let product = Product.mock()
        mockFetch.mockResponse = ProductResponse(
            products: [product], total: 1, skip: 0, limit: 20
        )
        await sut.loadInitial()
        sut.deleteProduct(product)
        XCTAssertTrue(sut.products.isEmpty)
    }

    func test_filterByCategory() async {
        let p1 = Product.mock(id: 1, category: "beauty")
        let p2 = Product.mock(id: 2, category: "furniture")
        mockFetch.mockResponse = ProductResponse(
            products: [p1, p2], total: 2, skip: 0, limit: 20
        )
        await sut.loadInitial()
        sut.selectedCategory = "beauty"
        XCTAssertEqual(sut.filteredProducts.count, 1)
        XCTAssertEqual(sut.filteredProducts.first?.category, "beauty")
    }
}
