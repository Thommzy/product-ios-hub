//
//  MockProductLocalDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/18/26.
//

@testable import ios_product_hub

final class MockProductLocalDataSource: ProductLocalDataSource {
    var cachedProducts: [Product] = []
    var saveCalled = false
    var addCalled = false
    var updateCalled = false
    var deleteCalled = false
    var deletedId: Int?
    var savedProducts: [Product] = []

    func fetchAll() -> [Product] { cachedProducts }

    func save(_ products: [Product]) {
        saveCalled = true
        savedProducts = products
        cachedProducts = products
    }

    func add(_ product: Product) {
        addCalled = true
        cachedProducts.append(product)
    }

    func update(_ product: Product) {
        updateCalled = true
        if let idx = cachedProducts.firstIndex(where: { $0.id == product.id }) {
            cachedProducts[idx] = product
        }
    }

    func delete(id: Int) {
        deleteCalled = true
        deletedId = id
        cachedProducts.removeAll { $0.id == id }
    }

    func deleteAll() {
        cachedProducts = []
    }
}
