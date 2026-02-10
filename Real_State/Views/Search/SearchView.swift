//
//  SearchView.swift
//  Real_State
//
//  Pestaña Search: solo el cuadro de búsqueda y los resultados.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var appState: AppState
    @State private var selectedProperty: Property?
    private let properties = MockData.properties

    private var filteredProperties: [Property] {
        guard !searchText.isEmpty else { return [] }
        let query = searchText.lowercased()
        return properties.filter {
            $0.title.lowercased().contains(query) ||
            $0.address.lowercased().contains(query) ||
            $0.city.lowercased().contains(query) ||
            $0.state.lowercased().contains(query)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBarView(text: $searchText)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))

                if searchText.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "Search properties",
                        systemImage: "magnifyingglass",
                        description: Text("Type an address, city, or property name.")
                    )
                } else if filteredProperties.isEmpty {
                    Spacer()
                    ContentUnavailableView.search(text: searchText)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredProperties) { property in
                                PropertyCardView(
                                    property: property,
                                    isSaved: appState.isSaved(property.id),
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
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedProperty) { property in
                PropertyDetailView(property: property)
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(AppState())
}
