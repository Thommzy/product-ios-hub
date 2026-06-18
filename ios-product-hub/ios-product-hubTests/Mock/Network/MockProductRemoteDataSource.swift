//
//  MockProductRemoteDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

@testable import ios_product_hub

final class MockProductRemoteDataSource: ProductRemoteDataSource {
    var mockResponse: ProductResponse = ProductResponse(
        products: [], total: 0, skip: 0, limit: 20
    )
    var shouldFail = false

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        if shouldFail { throw NetworkError.badResponse }
        return mockResponse
    }

    func searchProducts(
        query: String, limit: Int, skip: Int
    ) async throws -> ProductResponse {
        if shouldFail { throw NetworkError.badResponse }
        return mockResponse
    }
}
