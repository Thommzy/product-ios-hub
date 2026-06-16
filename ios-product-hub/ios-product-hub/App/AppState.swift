//
//  AppState.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
