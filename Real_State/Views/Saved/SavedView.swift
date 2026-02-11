//
//  SavedView.swift
//  Real_State
//
//  Pestaña Saved: lista de propiedades favoritas y estado vacío.
//

import SwiftUI

struct SavedView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedProperty: Property?
    private let properties = MockData.properties

    private var savedList: [Property] {
        appState.savedProperties(from: properties)
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedList.isEmpty {
                    emptyState
                } else {
                    savedListContent
                }
            }
            .navigationTitle("SWE Homes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedProperty) { property in
                PropertyDetailView(property: property)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.circle")
                .font(.system(size: 72))
                .foregroundStyle(AppTheme.accent.opacity(0.6))
            Text("Your saved homes")
                .font(.appTitle2)
            Text("Save properties you love by tapping the heart. They'll appear here easy to find.")
                .font(.appSubheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 60)
    }

    private var savedListContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(savedList) { property in
                    PropertyCardView(
                        property: property,
                        isSaved: true,
                        onTap: { selectedProperty = property },
                        onFavorite: { appState.toggleSaved(property.id) }
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SavedView()
        .environmentObject(AppState())
}
