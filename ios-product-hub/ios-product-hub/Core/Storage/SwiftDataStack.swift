//
//  SwiftDataStack.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataStack {
    let container: ModelContainer

    init() {
        let schema = Schema([
            ProductEntity.self,
            FavoriteEntity.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create SwiftData container: \(error)")
        }
    }

    var context: ModelContext {
        container.mainContext
    }
}
