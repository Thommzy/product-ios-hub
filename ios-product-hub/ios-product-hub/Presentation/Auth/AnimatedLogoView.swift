//
//  AnimatedLogoView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

struct AnimatedLogoView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: CGFloat = 0
    @State private var rotation: Double = -15

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
                .scaleEffect(scale)
                .opacity(opacity)
                .rotationEffect(.degrees(rotation))

            Text("ProductHub")
                .font(.largeTitle).bold()
                .opacity(opacity)
                .offset(y: opacity == 0 ? 20 : 0)

            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                scale = 1.0
                opacity = 1.0
                rotation = 0
            }
        }
    }
}
