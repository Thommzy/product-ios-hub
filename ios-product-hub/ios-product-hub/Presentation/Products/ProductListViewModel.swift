//
//  ProductListViewModel.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import Foundation
import Combine

enum SortOption: String, CaseIterable {
    case none = "Default"
    case priceLow = "Price: Low to High"
    case priceHigh = "Price: High to Low"
    case rating = "Rating"
    case name = "Name"
}

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchQuery: String = ""
    @Published var selectedCategory: String = "All"
    @Published var sortOption: SortOption = .none
    @Published var hasMore: Bool = true

    private var currentSkip: Int = 0
    private let limit: Int = 20
    private var isLoadingMore: Bool = false

    private let fetchUseCase: FetchProductsUseCase
    private let searchUseCase: SearchProductsUseCase
    let favoritesUseCase: FavoritesUseCase
    let crudUseCase: ProductCRUDUseCase

    var categories: [String] {
        let cats = Set(products.map { $0.category })
        return ["All"] + cats.sorted()
    }

    var filteredProducts: [Product] {
        var result = products
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        switch sortOption {
        case .none: break
        case .priceLow: result.sort { $0.price < $1.price }
        case .priceHigh: result.sort { $0.price > $1.price }
        case .rating: result.sort { $0.rating > $1.rating }
        case .name: result.sort { $0.title < $1.title }
        }
        return result
    }

    init(
        fetchUseCase: FetchProductsUseCase,
        searchUseCase: SearchProductsUseCase,
        favoritesUseCase: FavoritesUseCase,
        crudUseCase: ProductCRUDUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.searchUseCase = searchUseCase
        self.favoritesUseCase = favoritesUseCase
        self.crudUseCase = crudUseCase
    }

    func loadInitial() async {
        currentSkip = 0
        products = []
        hasMore = true
        await load()
    }

    func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        await load()
    }

    private func load() async {
        isLoadingMore = true
        isLoading = products.isEmpty

        do {
            let response: ProductResponse
            if searchQuery.isEmpty {
                response = try await fetchUseCase.execute(limit: limit, skip: currentSkip)
            } else {
                response = try await searchUseCase.execute(
                    query: searchQuery, limit: limit, skip: currentSkip
                )
            }
            products.append(contentsOf: response.products)
            currentSkip += response.products.count
            hasMore = products.count < response.total
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isLoadingMore = false
    }

    func search() async {
        await loadInitial()
    }

    func toggleFavorite(product: Product) {
        favoritesUseCase.toggleFavorite(productId: product.id)
        objectWillChange.send()
    }

    func isFavorite(_ product: Product) -> Bool {
        favoritesUseCase.isFavorite(productId: product.id)
    }

    func deleteProduct(_ product: Product) {
        crudUseCase.deleteProduct(id: product.id)
        products.removeAll { $0.id == product.id }
    }

    func resetLocalChanges() async {
        isLoading = true
        do {
            let fresh = try await crudUseCase.resetLocalChanges()
            products = fresh
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
