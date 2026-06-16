//
//  ProductRepositoryProtocol.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol ProductRepositoryProtocol {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse
    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse
    func getCachedProducts() -> [Product]
    func saveProductsToCache(_ products: [Product])
    func addProduct(_ product: Product)
    func updateProduct(_ product: Product)
    func deleteProduct(id: Int)
    func resetLocalChanges() async throws -> [Product]
}
