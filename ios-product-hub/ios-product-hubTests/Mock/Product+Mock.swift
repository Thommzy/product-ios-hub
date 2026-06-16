//
//  Product+Mock.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

@testable import ios_product_hub

extension Product {
    static func mock(id: Int = 1, category: String = "beauty") -> Product {
        Product(
            id: id, title: "Test Product", description: "A test product",
            category: category, price: 9.99, discountPercentage: 10,
            rating: 4.5, stock: 50, tags: ["test"], brand: "TestBrand",
            sku: "TST-001", weight: 1,
            dimensions: Dimensions(width: 10, height: 10, depth: 10),
            warrantyInformation: "1 year", shippingInformation: "Ships in 3 days",
            availabilityStatus: "In Stock", reviews: [], returnPolicy: "30 days",
            minimumOrderQuantity: 1,
            meta: Meta(createdAt: "", updatedAt: "", barcode: "", qrCode: ""),
            images: [], thumbnail: ""
        )
    }
}
