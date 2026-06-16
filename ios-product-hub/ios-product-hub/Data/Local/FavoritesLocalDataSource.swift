//
//  FavoritesLocalDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData

protocol FavoritesLocalDataSource {
    func fetchAll() -> [Int]
    func add(productId: Int)
    func remove(productId: Int)
    func contains(productId: Int) -> Bool
}

@MainActor
final class FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    private let context: ModelContext
    init(stack: SwiftDataStack) { self.context = stack.context }

    func fetchAll() -> [Int] {
        let descriptor = FetchDescriptor<FavoriteEntity>()
        return (try? context.fetch(descriptor))?.map { $0.productId } ?? []
    }

    func add(productId: Int) {
        context.insert(FavoriteEntity(productId: productId))
        try? context.save()
    }

    func remove(productId: Int) {
        let descriptor = FetchDescriptor<FavoriteEntity>(
            predicate: #Predicate { $0.productId == productId }
        )
        if let entity = try? context.fetch(descriptor).first {
            context.delete(entity)
            try? context.save()
        }
    }

    func contains(productId: Int) -> Bool {
        let descriptor = FetchDescriptor<FavoriteEntity>(
            predicate: #Predicate { $0.productId == productId }
        )
        return (try? context.fetch(descriptor).first) != nil
    }
}
