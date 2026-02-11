//
//  ExploreViewModel.swift
//  Real_State
//
//  Lógica de exploración: búsqueda local, tipo de listado y filtros.
//

import Foundation
import Combine

/// Filtros aplicables en el sheet de filtros
struct PropertyFilters {
    var minPrice: Int = 0
    var maxPrice: Int = 5_000_000
    var minBedrooms: Int = 0
    var minBathrooms: Double = 0
    var newListingOnly: Bool = false
    var openHouseOnly: Bool = false
}

final class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: PropertyCategory = .residential
    @Published var selectedListingType: ListingType = .sale
    @Published var filters: PropertyFilters = PropertyFilters()
    @Published var isFilterSheetPresented: Bool = false
    @Published var isLoadingListings: Bool = true

    /// Filtra propiedades por categoría, tipo (Lease/Sale), búsqueda y filtros
    func filteredProperties(_ properties: [Property]) -> [Property] {
        var result = properties.filter { $0.category == selectedCategory && $0.listingType == selectedListingType }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.address.lowercased().contains(query) ||
                $0.city.lowercased().contains(query) ||
                $0.state.lowercased().contains(query)
            }
        }

        result = result.filter { $0.price >= filters.minPrice && $0.price <= filters.maxPrice }
        result = result.filter { $0.bedrooms >= filters.minBedrooms }
        result = result.filter { $0.bathrooms >= filters.minBathrooms }
        if filters.newListingOnly { result = result.filter { $0.isNewListing } }
        if filters.openHouseOnly { result = result.filter { $0.isOpenHouse } }

        return result
    }

    /// Propiedades destacadas (primeras 3 del resultado filtrado)
    func featuredProperties(_ properties: [Property]) -> [Property] {
        Array(filteredProperties(properties).prefix(3))
    }

    /// Hot Deals para el carrusel (más propiedades para scroll automático)
    func hotDealsProperties(_ properties: [Property]) -> [Property] {
        Array(filteredProperties(properties).prefix(8))
    }

    /// Simula carga inicial (para skeleton)
    func loadListings() {
        guard isLoadingListings else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.isLoadingListings = false
        }
    }
}
