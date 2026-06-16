//
//  ProductCRUDUseCase.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

protocol ProductCRUDUseCase {
    func addProduct(_ product: Product)
    func updateProduct(_ product: Product)
    func deleteProduct(id: Int)
    func resetLocalChanges() async throws -> [Product]
}

final class ProductCRUDUseCaseImpl: ProductCRUDUseCase {
    private let repository: ProductRepositoryProtocol
    init(repository: ProductRepositoryProtocol) { self.repository = repository }
    func addProduct(_ product: Product) { repository.addProduct(product) }
    func updateProduct(_ product: Product) { repository.updateProduct(product) }
    func deleteProduct(id: Int) { repository.deleteProduct(id: id) }
    func resetLocalChanges() async throws -> [Product] {
        try await repository.resetLocalChanges()
    }
}
