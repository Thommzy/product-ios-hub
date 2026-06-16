//
//  UndoToastView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct UndoToastView: View {
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Text("Product removed from favorites")
                .font(.subheadline)
            Spacer()
            Button("Undo", action: onUndo)
                .fontWeight(.semibold)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }
}
