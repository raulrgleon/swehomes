//
//  ContentView.swift
//  Real_State
//
//  Raíz con Tab Bar: Explore, Saved, Profile.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            ExploreView(searchBarOnTop: true, onDismissSearch: { selectedTab = 0 })
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(AppTheme.accent)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .environmentObject(appState)
    }
}

#Preview {
    ContentView()
}
