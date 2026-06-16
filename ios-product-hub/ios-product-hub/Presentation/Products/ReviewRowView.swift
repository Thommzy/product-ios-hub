//
//  ReviewRowView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct ReviewRowView: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.reviewerName).font(.subheadline).bold()
                Spacer()
                StarRatingView(rating: Double(review.rating))
            }
            Text(review.comment).font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
