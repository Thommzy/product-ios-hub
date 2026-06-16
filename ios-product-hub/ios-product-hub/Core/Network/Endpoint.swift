//
//  Endpoint.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation

enum Endpoint {
    case products(limit: Int, skip: Int)
    case searchProducts(query: String, limit: Int, skip: Int)

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        switch self {
        case .products(let limit, let skip):
            components.path = "/products"
            components.queryItems = [
                .init(name: "limit", value: "\(limit)"),
                .init(name: "skip", value: "\(skip)")
            ]
        case .searchProducts(let query, let limit, let skip):
            components.path = "/products/search"
            components.queryItems = [
                .init(name: "q", value: query),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "skip", value: "\(skip)")
            ]
        }
        return components.url
    }
}
