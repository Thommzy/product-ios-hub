//
//  OfflineBehaviourTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class OfflineBehaviourTests: XCTestCase {
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

    func test_networkFailure_setsErrorMessage() async {
        mockFetch.shouldFail = true
        await sut.loadInitial()
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.products.isEmpty)
    }

    func test_networkFailure_doesNotShowLoadingSpinner() async {
        mockFetch.shouldFail = true
        await sut.loadInitial()
        XCTAssertFalse(sut.isLoading)
    }

    func test_successAfterFailure_clearsError() async {
        mockFetch.shouldFail = true
        await sut.loadInitial()
        XCTAssertNotNil(sut.errorMessage)

        mockFetch.shouldFail = false
        mockFetch.mockResponse = ProductResponse(
            products: [Product.mock()], total: 1, skip: 0, limit: 20
        )
        await sut.loadInitial()
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.products.isEmpty)
    }

    func test_resetLocalChanges_reloadsFromRemote() async {
        mockCRUD.mockResetProducts = [Product.mock(id: 999)]
        await sut.resetLocalChanges()
        XCTAssertEqual(sut.products.first?.id, 999)
    }
}
