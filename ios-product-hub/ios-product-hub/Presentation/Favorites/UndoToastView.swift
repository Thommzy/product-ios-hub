//
//  UndoToastView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct UndoToastView: View {
    let onUndo: () -> Void
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        HStack {
            Text("product_removed".localized)
                .font(.subheadline)
            Spacer()
            Button("undo".localized, action: onUndo)
                .fontWeight(.semibold)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }
}
