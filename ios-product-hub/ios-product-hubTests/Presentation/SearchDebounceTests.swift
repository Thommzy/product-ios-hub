//
//  SearchDebounceTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class SearchDebounceTests: XCTestCase {
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

    func test_search_usesSearchUseCase() async {
        mockSearch.mockResponse = ProductResponse(
            products: [Product.mock(id: 99)], total: 1, skip: 0, limit: 20
        )
        sut.searchQuery = "mascara"
        await sut.search()
        XCTAssertEqual(sut.products.first?.id, 99)
    }

    func test_clearSearch_reloadsWithFetchUseCase() async {
        mockFetch.mockResponse = ProductResponse(
            products: [Product.mock(id: 1)], total: 1, skip: 0, limit: 20
        )
        sut.searchQuery = ""
        await sut.loadInitial()
        XCTAssertEqual(sut.products.first?.id, 1)
    }

    func test_pagination_appendsNextPage() async {
        let firstPage = (1...20).map { Product.mock(id: $0) }
        let secondPage = (21...40).map { Product.mock(id: $0) }

        mockFetch.mockResponse = ProductResponse(
            products: firstPage, total: 40, skip: 0, limit: 20
        )
        await sut.loadInitial()
        XCTAssertEqual(sut.products.count, 20)
        XCTAssertTrue(sut.hasMore)

        mockFetch.mockResponse = ProductResponse(
            products: secondPage, total: 40, skip: 20, limit: 20
        )
        await sut.loadMore()
        XCTAssertEqual(sut.products.count, 40)
        XCTAssertFalse(sut.hasMore)
    }

    func test_pagination_stopsWhenNoMore() async {
        let products = (1...5).map { Product.mock(id: $0) }
        mockFetch.mockResponse = ProductResponse(
            products: products, total: 5, skip: 0, limit: 20
        )
        await sut.loadInitial()
        XCTAssertFalse(sut.hasMore)
    }
}
