//
//  SortFilterView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct SortFilterView: View {
    @ObservedObject var viewModel: ProductListViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("sort_by".localized) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        HStack {
                            Text(option.rawValue)
                            Spacer()
                            if viewModel.sortOption == option {
                                Image(systemName: "checkmark").foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.sortOption = option }
                    }
                }

                Section("filter_by_category".localized) {
                    ForEach(viewModel.categories, id: \.self) { cat in
                        HStack {
                            Text(cat.capitalized)
                            Spacer()
                            if viewModel.selectedCategory == cat {
                                Image(systemName: "checkmark").foregroundStyle(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.selectedCategory = cat }
                    }
                }
            }
            .navigationTitle("sort_filter".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized) { dismiss() }
                }
            }
        }
    }
}
