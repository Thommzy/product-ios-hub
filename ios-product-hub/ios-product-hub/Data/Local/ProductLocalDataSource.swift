//
//  ProductLocalDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData
import Foundation

protocol ProductLocalDataSource {
    func fetchAll() -> [Product]
    func save(_ products: [Product])
    func add(_ product: Product)
    func update(_ product: Product)
    func delete(id: Int)
    func deleteAll()
}

@MainActor
final class ProductLocalDataSourceImpl: ProductLocalDataSource {
    private let context: ModelContext
    init(stack: SwiftDataStack) { self.context = stack.context }

    func fetchAll() -> [Product] {
        let descriptor = FetchDescriptor<ProductEntity>()
        return (try? context.fetch(descriptor))?.map { $0.toDomain() } ?? []
    }

    func save(_ products: [Product]) {
        deleteAll()
        products.forEach { context.insert(ProductEntity(from: $0)) }
        try? context.save()
    }

    func add(_ product: Product) {
        context.insert(ProductEntity(from: product, isLocalOnly: true))
        try? context.save()
    }

    func update(_ product: Product) {
        let id = product.id
        let descriptor = FetchDescriptor<ProductEntity>(
            predicate: #Predicate { $0.id == id }
        )
        if let entity = try? context.fetch(descriptor).first {
            entity.title = product.title
            entity.price = product.price
            entity.desc = product.description
            entity.stock = product.stock
            try? context.save()
        }
    }

    func delete(id: Int) {
        let descriptor = FetchDescriptor<ProductEntity>(
            predicate: #Predicate { $0.id == id }
        )
        if let entity = try? context.fetch(descriptor).first {
            context.delete(entity)
            try? context.save()
        }
    }

    func deleteAll() {
        try? context.delete(model: ProductEntity.self)
    }
}
