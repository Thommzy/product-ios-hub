//
//  ProductDetailView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var languageManager: LanguageManager
    let product: Product
    @ObservedObject var viewModel: ProductListViewModel
    @State private var showEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Images
                TabView {
                    ForEach(product.images, id: \.self) { url in
                        AsyncImage(url: URL(string: url)) { image in
                            image.resizable().aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray.opacity(0.2)
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(product.title)
                            .font(.title2).bold()
                        Spacer()
                        Button {
                            viewModel.toggleFavorite(product: product)
                        } label: {
                            Image(systemName: viewModel.isFavorite(product) ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundStyle(viewModel.isFavorite(product) ? .red : .gray)
                        }
                    }

                    Text(product.category.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("$\(product.discountedPrice, specifier: "%.2f")")
                            .font(.title3).bold().foregroundStyle(.green)
                        if product.discountPercentage > 0 {
                            Text("$\(product.price, specifier: "%.2f")")
                                .strikethrough().foregroundStyle(.secondary)
                            Text("\(product.discountPercentage, specifier: "%.0f")% \("off".localized)")
                                .font(.caption).foregroundStyle(.orange)
                        }
                    }

                    StarRatingView(rating: product.rating)

                    Divider()

                    Text("description".localized)
                        .font(.headline)
                    Text(product.description)
                        .foregroundStyle(.secondary)

                    Divider()

                    infoRow("brand".localized, product.brand ?? "na".localized)
                    infoRow("sku".localized, product.sku)
                    infoRow("stock".localized, "\(product.stock) \("units".localized)")
                    infoRow("status".localized, product.availabilityStatus)
                    infoRow("warranty".localized, product.warrantyInformation)
                    infoRow("shipping".localized, product.shippingInformation)
                    infoRow("return_policy".localized, product.returnPolicy)

                    Divider()

                    Text("\("reviews".localized) (\(product.reviews.count))")
                        .font(.headline)

                    ForEach(product.reviews, id: \.reviewerEmail) { review in
                        ReviewRowView(review: review)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("edit".localized) { showEdit = true }
            }
        }
        .sheet(isPresented: $showEdit) {
            AddEditProductView(viewModel: viewModel, product: product)
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary).frame(width: 110, alignment: .leading)
            Text(value).fontWeight(.medium)
        }
        .font(.subheadline)
    }
}
