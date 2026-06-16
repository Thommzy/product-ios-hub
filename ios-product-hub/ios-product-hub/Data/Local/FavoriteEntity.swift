//
//  FavoriteEntity.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData
import Foundation

@Model
final class FavoriteEntity {
    @Attribute(.unique) var productId: Int
    var addedAt: Date

    init(productId: Int) {
        self.productId = productId
        self.addedAt = Date()
    }
}
