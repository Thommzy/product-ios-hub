//
//  SearchProductsUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol SearchProductsUseCase {
    func execute(query: String, limit: Int, skip: Int) async throws -> ProductResponse
}

final class SearchProductsUseCaseImpl: SearchProductsUseCase {
    private let repository: ProductRepositoryProtocol
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    func execute(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        try await repository.searchProducts(query: query, limit: limit, skip: skip)
    }
}
