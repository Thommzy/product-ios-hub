//
//  ProductListView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var viewModel: ProductListViewModel
    @State private var showAddProduct = false
    @State private var selectedProduct: Product? = nil
    @State private var showSortFilter = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.products.isEmpty {
                    ProgressView("loading_products".localized)
                } else if let error = viewModel.errorMessage, viewModel.products.isEmpty {
                    ErrorView(message: error) {
                        Task { await viewModel.loadInitial() }
                    }
                } else {
                    productList
                }
            }
            .navigationTitle("products".localized)
            .searchable(text: $viewModel.searchQuery, prompt: "search_products".localized)
            .onSubmit(of: .search) {
                Task { await viewModel.search() }
            }
            .onChange(of: viewModel.searchQuery) { _, new in
                if new.isEmpty {
                    Task { await viewModel.loadInitial() }
                } else {
                    viewModel.debouncedSearch()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("reset".localized) { Task { await viewModel.resetLocalChanges() } }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            showSortFilter = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                        }
                        Button {
                            showAddProduct = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddProduct) {
                AddEditProductView(viewModel: viewModel, product: nil)
            }
            .sheet(isPresented: $showSortFilter) {
                SortFilterView(viewModel: viewModel)
            }
            .task { await viewModel.loadInitial() }
        }
    }

    private var productList: some View {
        List {
            ForEach(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(
                    product: product,
                    viewModel: viewModel
                )) {
                    ProductRowView(
                        product: product,
                        isFavorite: viewModel.isFavorite(product)
                    ) {
                        viewModel.toggleFavorite(product: product)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.deleteProduct(product)
                    } label: {
                        Label("delete".localized, systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        selectedProduct = product
                    } label: {
                        Label("edit".localized, systemImage: "pencil")
                    }
                    .tint(.blue)
                }
                .task {
                    if product.id == viewModel.filteredProducts.last?.id {
                        await viewModel.loadMore()
                    }
                }
            }
            if viewModel.hasMore {
                HStack { Spacer(); ProgressView(); Spacer() }
            }
        }
        .listStyle(.plain)
        .sheet(item: $selectedProduct) { product in
            AddEditProductView(viewModel: viewModel, product: product)
        }
    }
}
