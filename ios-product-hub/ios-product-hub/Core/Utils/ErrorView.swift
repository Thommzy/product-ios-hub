//
//  ErrorView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle).foregroundStyle(.orange)
            Text(message)
                .multilineTextAlignment(.center).foregroundStyle(.secondary)
            Button("retry".localized, action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
