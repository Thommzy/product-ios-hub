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
        do {
            return try context.fetch(descriptor).map { $0.toDomain() }
        } catch {
            print("SwiftData fetch error: \(error)")
            return []
        }
    }

    func save(_ products: [Product]) {
        do {
            deleteAll()
            products.forEach { context.insert(ProductEntity(from: $0)) }
            try context.save()
        } catch {
            print("SwiftData save error: \(error)")
        }
    }

    func add(_ product: Product) {
        do {
            context.insert(ProductEntity(from: product, isLocalOnly: true))
            try context.save()
        } catch {
            print("SwiftData add error: \(error)")
        }
    }

    func update(_ product: Product) {
        let id = product.id
        let descriptor = FetchDescriptor<ProductEntity>(
            predicate: #Predicate { $0.id == id }
        )
        do {
            if let entity = try context.fetch(descriptor).first {
                entity.title = product.title
                entity.price = product.price
                entity.desc = product.description
                entity.stock = product.stock
                try context.save()
            }
        } catch {
            print("SwiftData update error: \(error)")
        }
    }

    func delete(id: Int) {
        let descriptor = FetchDescriptor<ProductEntity>(
            predicate: #Predicate { $0.id == id }
        )
        do {
            if let entity = try context.fetch(descriptor).first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            print("SwiftData delete error: \(error)")
        }
    }

    func deleteAll() {
        do {
            try context.delete(model: ProductEntity.self)
        } catch {
            print("SwiftData deleteAll error: \(error)")
        }
    }
}
