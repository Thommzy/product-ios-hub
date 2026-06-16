//
//  ProductRepository.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

final class ProductRepository: ProductRepositoryProtocol {
    private let remote: ProductRemoteDataSource
    private let local: ProductLocalDataSource

    init(remote: ProductRemoteDataSource, local: ProductLocalDataSource) {
        self.remote = remote
        self.local = local
    }

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        do {
            let response = try await remote.fetchProducts(limit: limit, skip: skip)
            if skip == 0 { await MainActor.run { local.save(response.products) } }
            return response
        } catch {
            let cached = await MainActor.run { local.fetchAll() }
            if !cached.isEmpty {
                return ProductResponse(products: cached, total: cached.count, skip: 0, limit: cached.count)
            }
            throw error
        }
    }

    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        try await remote.searchProducts(query: query, limit: limit, skip: skip)
    }

    func getCachedProducts() -> [Product] { local.fetchAll() }
    func saveProductsToCache(_ products: [Product]) { local.save(products) }
    func addProduct(_ product: Product) { local.add(product) }
    func updateProduct(_ product: Product) { local.update(product) }
    func deleteProduct(id: Int) { local.delete(id: id) }

    func resetLocalChanges() async throws -> [Product] {
        let response = try await remote.fetchProducts(limit: 30, skip: 0)
        await MainActor.run { local.save(response.products) }
        return response.products
    }
}
