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
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No saved properties")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap the heart on any listing to save it here.")
                .font(.subheadline)
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
