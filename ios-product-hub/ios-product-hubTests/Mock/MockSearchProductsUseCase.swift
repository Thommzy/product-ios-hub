//
//  MockSearchProductsUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockSearchProductsUseCase: SearchProductsUseCase {
    var mockResponse: ProductResponse = ProductResponse(products: [], total: 0, skip: 0, limit: 20)

    func execute(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        return mockResponse
    }
}
