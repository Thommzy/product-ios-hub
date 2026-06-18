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

    private var searchTask: Task<Void, Never>? = nil
    private var debounceTask: Task<Void, Never>? = nil
    private var loadMoreTask: Task<Void, Never>? = nil

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

    deinit {
        searchTask?.cancel()
        debounceTask?.cancel()
        loadMoreTask?.cancel()
    }

    func loadInitial() async {
        currentSkip = 0
        products = []
        hasMore = true
        await load()
    }

    func loadMore() async {
        guard hasMore, !isLoadingMore else { return }
        loadMoreTask?.cancel()
        loadMoreTask = Task {
            await load()
        }
        await loadMoreTask?.value
    }

    private func load() async {
        guard !Task.isCancelled else { return }
        isLoadingMore = true
        isLoading = products.isEmpty

        do {
            let response: ProductResponse
            if searchQuery.isEmpty {
                response = try await fetchUseCase.execute(
                    limit: limit, skip: currentSkip
                )
            } else {
                response = try await searchUseCase.execute(
                    query: searchQuery, limit: limit, skip: currentSkip
                )
            }
            guard !Task.isCancelled else { return }
            products.append(contentsOf: response.products)
            currentSkip += response.products.count
            hasMore = products.count < response.total
            errorMessage = nil
        } catch is CancellationError {
            // silently ignore cancelled tasks
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
        isLoadingMore = false
    }

    // Called from .onChange on searchQuery
    func debouncedSearch() {
        debounceTask?.cancel()
        debounceTask = Task {
            // wait 400ms — if cancelled before then, skip
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await search()
        }
    }

    func search() async {
        // cancel any in-flight search
        searchTask?.cancel()
        searchTask = Task {
            await loadInitial()
        }
        await searchTask?.value
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
