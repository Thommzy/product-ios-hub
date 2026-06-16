//
//  ProductEntity.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftData
import Foundation

@Model
final class ProductEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var desc: String
    var category: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String?
    var sku: String
    var thumbnail: String
    var images: [String]
    var availabilityStatus: String
    var isLocalOnly: Bool

    init(from product: Product, isLocalOnly: Bool = false) {
        self.id = product.id
        self.title = product.title
        self.desc = product.description
        self.category = product.category
        self.price = product.price
        self.discountPercentage = product.discountPercentage
        self.rating = product.rating
        self.stock = product.stock
        self.brand = product.brand
        self.sku = product.sku
        self.thumbnail = product.thumbnail
        self.images = product.images
        self.availabilityStatus = product.availabilityStatus
        self.isLocalOnly = isLocalOnly
    }

    func toDomain() -> Product {
        Product(
            id: id, title: title, description: desc, category: category,
            price: price, discountPercentage: discountPercentage,
            rating: rating, stock: stock, tags: [], brand: brand, sku: sku,
            weight: 0, dimensions: Dimensions(width: 0, height: 0, depth: 0),
            warrantyInformation: "", shippingInformation: "",
            availabilityStatus: availabilityStatus, reviews: [],
            returnPolicy: "", minimumOrderQuantity: 1,
            meta: Meta(createdAt: "", updatedAt: "", barcode: "", qrCode: ""),
            images: images, thumbnail: thumbnail
        )
    }
}
