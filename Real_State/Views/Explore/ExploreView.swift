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
    @State private var isPushBannerVisible = true
    @State private var toastMessage: String?
    private let properties = PropertyRepository.shared.fetchProperties()

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

                // V3: Push Notification Banner Mock
                VStack {
                    if isPushBannerVisible {
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                            toastMessage = "Navigating to Price Drop Property..."
                            withAnimation(.easeOut(duration: 0.3)) {
                                isPushBannerVisible = false
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundStyle(.red)
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Price dropped near you!")
                                        .font(.subheadline).bold()
                                    Text("A saved property in Midtown just dropped 10%.")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .multilineTextAlignment(.leading)
                                Spacer()
                                
                                Button {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        isPushBannerVisible = false
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .font(.title3)
                                }
                                .padding(.leading, 8)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .onAppear {
                            // Auto dismiss after 8 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    isPushBannerVisible = false
                                }
                            }
                        }
                    }
                    Spacer()
                }

                // V3: AI Chat Assistant FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            toastMessage = "Launching AI Realtor Assistant..."
                        } label: {
                            Image(systemName: "sparkles")
                                .font(.title.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    LinearGradient(colors: [.purple, .indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(Circle())
                                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .padding(.trailing, 20)
                        .padding(.bottom, searchBarOnTop ? 100 : 20)
                    }
                }
            }
            .navigationTitle("SWE Homes")
            .navigationBarTitleDisplayMode(.inline)
            .toast(message: $toastMessage)
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
            .onAppear { viewModel.loadListings() }
        }
    }

    private var emptyListingsState: some View {
        VStack(spacing: 20) {
            Image(systemName: "building.2.trianglebadge.exclamationmark")
                .font(.system(size: 56))
                .foregroundStyle(.secondary.opacity(0.7))
            Text("No properties found")
                .font(.appHeadline)
            Text("Try adjusting your search or filters to see more listings.")
                .font(.appSubheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
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
        HotDealsCarouselView(
            properties: viewModel.hotDealsProperties(properties),
            onSelect: { property in
                if searchBarOnTop, !viewModel.searchText.isEmpty {
                    appState.addSearchHistory(viewModel.searchText)
                }
                selectedProperty = property
            },
            cardContent: { featuredCard($0) }
        )
    }

    private func featuredCard(_ property: Property) -> some View {
        Button {
            if searchBarOnTop, !viewModel.searchText.isEmpty {
                appState.addSearchHistory(viewModel.searchText)
            }
            selectedProperty = property
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    PropertyImageView(property: property, height: 160, width: 280)
                    Text("🔥 Hot")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.thinMaterial)
                        .background(AppTheme.hotOrange.opacity(0.8))
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .padding(12)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(property.priceFormatted)
                        .font(.appHeadline)
                    Text(property.fullAddress)
                        .font(.appCaption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            .frame(width: 280)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var propertyListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Listings")
                .font(.appTitle2)
                .padding(.horizontal)
            let filtered = viewModel.filteredProperties(properties)
            if viewModel.isLoadingListings {
                LazyVStack(spacing: 16) {
                    ForEach(0..<4, id: \.self) { _ in
                        SkeletonPropertyCard()
                            .padding(.horizontal)
                    }
                }
            } else if filtered.isEmpty {
                emptyListingsState
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(filtered) { property in
                        PropertyCardView(
                            property: property,
                            isSaved: appState.isSaved(property.id),
                            onTap: {
                                if searchBarOnTop, !viewModel.searchText.isEmpty {
                                    appState.addSearchHistory(viewModel.searchText)
                                }
                                selectedProperty = property
                            },
                            onFavorite: {
                                appState.toggleSaved(property.id)
                                toastMessage = appState.isSaved(property.id) ? "Saved to favorites" : "Removed from favorites"
                            }
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

// MARK: - Hot Deals Carousel

private struct HotDealsCarouselView<Card: View>: View {
    let properties: [Property]
    let onSelect: (Property) -> Void
    @ViewBuilder let cardContent: (Property) -> Card

    @State private var currentIndex = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hot Deals!")
                .font(.appTitle2)
                .padding(.horizontal)
                .accessibilityAddTraits(.isHeader)

            if properties.isEmpty {
                Color.clear.frame(height: 1)
            } else {
                GeometryReader { geo in
                    let width = geo.size.width
                    let cardWidth: CGFloat = 280
                    let spacing: CGFloat = 16
                    let centerPadding = max(0, (width - cardWidth) / 2 - spacing / 2)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: spacing) {
                                ForEach(Array(properties.enumerated()), id: \.element.id) { index, property in
                                    Button {
                                        onSelect(property)
                                    } label: {
                                        cardContent(property)
                                    }
                                    .buttonStyle(.plain)
                                    .id(index)
                                }
                            }
                            .padding(.leading, centerPadding)
                            .padding(.trailing, centerPadding)
                        }
                        .onAppear {
                            proxy.scrollTo(0, anchor: .center)
                            startCarousel(proxy: proxy)
                        }
                        .onDisappear {
                            timer?.invalidate()
                        }
                    }
                }
                .frame(height: 220)
            }
        }
    }

    private func startCarousel(proxy: ScrollViewProxy) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % max(1, properties.count)
                proxy.scrollTo(currentIndex, anchor: .center)
            }
        }
        timer?.tolerance = 0.3
        RunLoop.main.add(timer!, forMode: .common)
    }
}

#Preview {
    ExploreView()
        .environmentObject(AppState())
}
