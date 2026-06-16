//
//  FetchProductsUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol FetchProductsUseCase {
    func execute(limit: Int, skip: Int) async throws -> ProductResponse
}

final class FetchProductsUseCaseImpl: FetchProductsUseCase {
    private let repository: ProductRepositoryProtocol
    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }
    func execute(limit: Int, skip: Int) async throws -> ProductResponse {
        try await repository.fetchProducts(limit: limit, skip: skip)
    }
}
