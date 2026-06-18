//
//  MockCRUDUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

final class MockCRUDUseCase: ProductCRUDUseCase {
    var mockResetProducts: [Product] = []
    var shouldFailReset = false

    func addProduct(_ product: Product) {}
    func updateProduct(_ product: Product) {}
    func deleteProduct(id: Int) {}
    func resetLocalChanges() async throws -> [Product] {
        if shouldFailReset { throw NetworkError.badResponse }
        return mockResetProducts
    }
}
