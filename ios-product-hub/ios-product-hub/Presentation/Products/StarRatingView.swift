//
//  StarRatingView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { i in
                Image(systemName: starName(for: i))
                    .foregroundStyle(.yellow)
                    .font(.caption)
            }
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func starName(for index: Int) -> String {
        let val = rating - Double(index)
        if val >= 1 { return "star.fill" }
        if val >= 0.5 { return "star.leadinghalf.filled" }
        return "star"
    }
}
