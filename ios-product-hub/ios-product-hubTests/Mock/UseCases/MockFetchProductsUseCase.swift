//
//  MockFetchProductsUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockFetchProductsUseCase: FetchProductsUseCase {
    var mockResponse: ProductResponse = ProductResponse(products: [], total: 0, skip: 0, limit: 20)
    var shouldFail = false

    func execute(limit: Int, skip: Int) async throws -> ProductResponse {
        if shouldFail { throw NetworkError.badResponse }
        return mockResponse
    }
}
