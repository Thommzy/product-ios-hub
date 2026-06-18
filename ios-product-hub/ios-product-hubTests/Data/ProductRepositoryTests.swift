//
//  ProductRepositoryTests.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

import XCTest
@testable import ios_product_hub

@MainActor
final class ProductRepositoryTests: XCTestCase {
    var sut: ProductRepository!
    var mockRemote: MockProductRemoteDataSource!
    var mockLocal: MockProductLocalDataSource!

    override func setUp() {
        mockRemote = MockProductRemoteDataSource()
        mockLocal = MockProductLocalDataSource()
        sut = ProductRepository(remote: mockRemote, local: mockLocal)
    }

    // MARK: - Fetch Products

    func test_fetchProducts_success_savesToLocalCache() async throws {
        let products = [Product.mock(id: 1), Product.mock(id: 2)]
        mockRemote.mockResponse = ProductResponse(
            products: products, total: 2, skip: 0, limit: 20
        )
        _ = try await sut.fetchProducts(limit: 20, skip: 0)
        XCTAssertTrue(mockLocal.saveCalled)
        XCTAssertEqual(mockLocal.savedProducts.count, 2)
    }

    func test_fetchProducts_success_doesNotSaveCacheOnSubsequentPages() async throws {
        let products = [Product.mock(id: 21)]
        mockRemote.mockResponse = ProductResponse(
            products: products, total: 40, skip: 20, limit: 20
        )
        _ = try await sut.fetchProducts(limit: 20, skip: 20)
        XCTAssertFalse(mockLocal.saveCalled)
    }

    func test_fetchProducts_networkFailure_returnsCachedProducts() async throws {
        mockRemote.shouldFail = true
        mockLocal.cachedProducts = [Product.mock(id: 99)]
        let response = try await sut.fetchProducts(limit: 20, skip: 0)
        XCTAssertEqual(response.products.first?.id, 99)
    }

    func test_fetchProducts_networkFailure_emptyCache_throws() async {
        mockRemote.shouldFail = true
        mockLocal.cachedProducts = []
        do {
            _ = try await sut.fetchProducts(limit: 20, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - CRUD

    func test_addProduct_callsLocalAdd() {
        let product = Product.mock(id: 1)
        sut.addProduct(product)
        XCTAssertTrue(mockLocal.addCalled)
    }

    func test_updateProduct_callsLocalUpdate() {
        let product = Product.mock(id: 1)
        sut.updateProduct(product)
        XCTAssertTrue(mockLocal.updateCalled)
    }

    func test_deleteProduct_callsLocalDelete() {
        sut.deleteProduct(id: 1)
        XCTAssertTrue(mockLocal.deleteCalled)
        XCTAssertEqual(mockLocal.deletedId, 1)
    }

    // MARK: - Reset

    func test_resetLocalChanges_fetchesFromRemoteAndSavesLocally() async throws {
        let products = [Product.mock(id: 1)]
        mockRemote.mockResponse = ProductResponse(
            products: products, total: 1, skip: 0, limit: 30
        )
        let result = try await sut.resetLocalChanges()
        XCTAssertEqual(result.count, 1)
        XCTAssertTrue(mockLocal.saveCalled)
    }

    func test_resetLocalChanges_networkFailure_throws() async {
        mockRemote.shouldFail = true
        do {
            _ = try await sut.resetLocalChanges()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
