//
//  SettingsView.swift
//  ios-product-hub
//
//  Created by Timothy Obeisun on 6/16/26.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var appState: AppState
    @AppStorage("appColorScheme") private var colorScheme: String = "system"
    @AppStorage("appLanguage") private var language: String = "en"
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $colorScheme) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.segmented)
                }

                Section("Language") {
                    Picker("Language", selection: $language) {
                        Text("English").tag("en")
                        Text("עברית").tag("he")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: language) { _, new in
                        UserDefaults.standard.set([new], forKey: "AppleLanguages")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(resolvedColorScheme)
            .alert("Sign Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    viewModel.logout(appState: appState)
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }

    private var resolvedColorScheme: ColorScheme? {
        switch colorScheme {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
