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
    @EnvironmentObject var languageManager: LanguageManager
    @AppStorage("appColorScheme") private var colorScheme: String = "system"
    @State private var showLogoutAlert = false
    @State private var showRestartAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("appearance".localized) {
                    Picker("theme".localized, selection: $colorScheme) {
                        Text("system".localized).tag("system")
                        Text("light".localized).tag("light")
                        Text("dark".localized).tag("dark")
                    }
                    .pickerStyle(.segmented)
                }

                Section("language".localized) {
                    Picker("language".localized, selection: $languageManager.currentLanguage) {
                        Text("English").tag("en")
                        Text("עברית").tag("he")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: languageManager.currentLanguage) { _, _ in
                        showRestartAlert = true
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("sign_out".localized)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("settings".localized)
            .preferredColorScheme(resolvedColorScheme)
            .environment(\.layoutDirection, languageManager.isRTL ? .rightToLeft : .leftToRight)
            .alert("sign_out".localized, isPresented: $showLogoutAlert) {
                Button("cancel".localized, role: .cancel) {}
                Button("sign_out".localized, role: .destructive) {
                    viewModel.logout(appState: appState)
                }
            }
            .alert("Language Changed", isPresented: $showRestartAlert) {
                Button("OK") {}
            } message: {
                Text("Please restart the app to apply the new language.")
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
