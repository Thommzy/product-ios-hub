//
//  FavoritesLocalDataSource.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData
import Foundation

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
        do {
            return try context.fetch(FetchDescriptor<FavoriteEntity>())
                .map { $0.productId }
        } catch {
            print("SwiftData favorites fetch error: \(error)")
            return []
        }
    }

    func add(productId: Int) {
        do {
            context.insert(FavoriteEntity(productId: productId))
            try context.save()
        } catch {
            print("SwiftData favorites add error: \(error)")
        }
    }

    func remove(productId: Int) {
        let descriptor = FetchDescriptor<FavoriteEntity>(
            predicate: #Predicate { $0.productId == productId }
        )
        do {
            if let entity = try context.fetch(descriptor).first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            print("SwiftData favorites remove error: \(error)")
        }
    }

    func contains(productId: Int) -> Bool {
        let descriptor = FetchDescriptor<FavoriteEntity>(
            predicate: #Predicate { $0.productId == productId }
        )
        do {
            return try context.fetch(descriptor).first != nil
        } catch {
            print("SwiftData favorites contains error: \(error)")
            return false
        }
    }
}
