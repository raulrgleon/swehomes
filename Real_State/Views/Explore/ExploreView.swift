//
//  ExploreView.swift
//  Real_State
//
//  Pestaña Explore: búsqueda, filtros, categoría For Sale/For Rent, destacados y lista.
//

import SwiftUI
import MapKit
import UIKit

struct ExploreView: View {
    /// Si es true (pestaña Search), la barra de búsqueda va fija encima de todo.
    var searchBarOnTop: Bool = false
    /// Al tocar fuera en Search, se llama y se vuelve a Home.
    var onDismissSearch: (() -> Void)? = nil
    @StateObject private var viewModel = ExploreViewModel()
    @EnvironmentObject var appState: AppState
    @State private var selectedProperty: Property?
    @State private var selectedPropertyIdForMap: UUID?
    @State private var isFloatingSearchVisible = true
    private let properties = MockData.properties

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(PropertyCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.segmented)

                        HStack {
                            Picker("Listing type", selection: $viewModel.selectedListingType) {
                                ForEach(ListingType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            Button {
                                viewModel.isFilterSheetPresented = true
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.horizontal)

                    featuredSection
                    mapSection
                    propertyListSection
                }
                .padding(.bottom, searchBarOnTop ? 100 : 24)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if searchBarOnTop {
                        hideKeyboard()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onDismissSearch?()
                        }
                    }
                }
                .scrollDismissesKeyboard(.immediately)

                if searchBarOnTop {
                    VStack {
                        Spacer(minLength: 0)
                        if isFloatingSearchVisible {
                            SearchBarView(text: $viewModel.searchText)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 8)
                        } else {
                            Button {
                                isFloatingSearchVisible = true
                            } label: {
                                Label("Search", systemImage: "magnifyingglass")
                                    .font(.subheadline.weight(.medium))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                        }
                    }
                    .allowsHitTesting(true)
                }
            }
            .navigationTitle("SWE Homes")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.isFilterSheetPresented) {
                FilterSheetView(viewModel: viewModel)
            }
            .navigationDestination(item: $selectedProperty) { property in
                PropertyDetailView(property: property)
            }
            .onChange(of: selectedPropertyIdForMap) { _, newId in
                if let id = newId, let p = viewModel.filteredProperties(properties).first(where: { $0.id == id }) {
                    selectedProperty = p
                }
            }
        }
    }

    private var mapSection: some View {
        MapPreviewView(
            properties: viewModel.filteredProperties(properties),
            selectedPropertyId: $selectedPropertyIdForMap,
            defaultCenter: MockData.houstonCenter
        )
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredProperties(properties)) { property in
                        featuredCard(property)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func featuredCard(_ property: Property) -> some View {
        Button {
            selectedProperty = property
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HeroPlaceholderView(styleIndex: property.imageStyleIndex)
                    .frame(width: 280, height: 160)
                VStack(alignment: .leading, spacing: 4) {
                    Text(property.priceFormatted)
                        .font(.headline)
                    Text(property.fullAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            .frame(width: 280)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var propertyListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Listings")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)
            let filtered = viewModel.filteredProperties(properties)
            if filtered.isEmpty {
                ContentUnavailableView(
                    "No properties",
                    systemImage: "building.2",
                    description: Text("Try adjusting search or filters.")
                )
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filtered) { property in
                        PropertyCardView(
                            property: property,
                            isSaved: appState.isSaved(property.id),
                            onTap: { selectedProperty = property },
                            onFavorite: { appState.toggleSaved(property.id) }
                        )
                        .padding(.horizontal)
                    }
                }
            }
        }
    }

    private func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .first { $0.isKeyWindow }?
                .endEditing(true)
        }
    }
}

#Preview {
    ExploreView()
        .environmentObject(AppState())
}
