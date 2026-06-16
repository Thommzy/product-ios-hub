//
//  ProductRemoteDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol ProductRemoteDataSource {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse
    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse
}

final class ProductRemoteDataSourceImpl: ProductRemoteDataSource {
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) { self.networkService = networkService }

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        try await networkService.request(.products(limit: limit, skip: skip))
    }

    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        try await networkService.request(.searchProducts(query: query, limit: limit, skip: skip))
    }
}
