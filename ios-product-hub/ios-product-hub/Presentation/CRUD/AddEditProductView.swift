//
//  AddEditProductView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct AddEditProductView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @ObservedObject var viewModel: ProductListViewModel
    let product: Product?
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var category: String = ""

    var isEditing: Bool { product != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("product_info".localized) {
                    TextField("title".localized, text: $title)
                    TextField("category".localized, text: $category)
                    TextField("price".localized, text: $price)
                        .keyboardType(.decimalPad)
                    TextField("stock".localized, text: $stock)
                        .keyboardType(.numberPad)
                }
                Section("description".localized) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditing ? "edit_product".localized : "add_product".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel".localized, role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save".localized) { save() }
                        .disabled(title.isEmpty || price.isEmpty)
                }
            }
            .onAppear { prefill() }
        }
    }

    private func prefill() {
        guard let p = product else { return }
        title = p.title
        description = p.description
        price = String(p.price)
        stock = String(p.stock)
        category = p.category
    }

    private func save() {
        let newProduct = Product(
            id: product?.id ?? Int.random(in: 10000...99999),
            title: title,
            description: description,
            category: category,
            price: Double(price) ?? 0,
            discountPercentage: product?.discountPercentage ?? 0,
            rating: product?.rating ?? 0,
            stock: Int(stock) ?? 0,
            tags: product?.tags ?? [],
            brand: product?.brand,
            sku: product?.sku ?? "LOCAL-\(UUID().uuidString.prefix(8))",
            weight: product?.weight ?? 0,
            dimensions: product?.dimensions ?? Dimensions(width: 0, height: 0, depth: 0),
            warrantyInformation: product?.warrantyInformation ?? "",
            shippingInformation: product?.shippingInformation ?? "",
            availabilityStatus: "In Stock",
            reviews: product?.reviews ?? [],
            returnPolicy: product?.returnPolicy ?? "",
            minimumOrderQuantity: product?.minimumOrderQuantity ?? 1,
            meta: product?.meta ?? Meta(createdAt: "", updatedAt: "", barcode: "", qrCode: ""),
            images: product?.images ?? [],
            thumbnail: product?.thumbnail ?? ""
        )

        if isEditing {
            viewModel.crudUseCase.updateProduct(newProduct)
            if let idx = viewModel.products.firstIndex(where: { $0.id == newProduct.id }) {
                viewModel.products[idx] = newProduct
            }
        } else {
            viewModel.crudUseCase.addProduct(newProduct)
            viewModel.products.insert(newProduct, at: 0)
        }
        dismiss()
    }
}
