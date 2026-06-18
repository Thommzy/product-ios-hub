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
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            // If persistent store fails, fall back to in-memory
            // This prevents a crash while still giving the app a usable state
            do {
                let fallbackConfig = ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: true
                )
                container = try ModelContainer(
                    for: schema,
                    configurations: fallbackConfig
                )
            } catch {
                fatalError("SwiftData failed to initialise even in-memory: \(error)")
            }
        }
    }

    var context: ModelContext {
        container.mainContext
    }
}
