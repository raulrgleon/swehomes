//
//  ExploreViewModel.swift
//  Real_State
//
//  Lógica de exploración: búsqueda local, tipo de listado y filtros.
//

import Foundation
import Combine

/// Filtros aplicables en el sheet de filtros
struct PropertyFilters: Equatable {
    var minPrice: Int = 0
    var maxPrice: Int = 5_000_000
    var minBedrooms: Int = 0
    var minBathrooms: Double = 0
    var ownerFinancingOnly: Bool = false
    /// Incluir vendidas, arrendadas y no disponibles
    var includeInactive: Bool = false
}

final class ExploreViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedCategory: PropertyCategory = .residential
    @Published var selectedListingType: ListingType = .sale
    @Published var filters: PropertyFilters = PropertyFilters()
    @Published var isFilterSheetPresented: Bool = false
    @Published var isLoadingListings: Bool = true

    /// Filtra propiedades por categoría, tipo (Lease/Sale), búsqueda, estado y filtros
    func filteredProperties(_ properties: [Property]) -> [Property] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return properties.filter { p in
            guard p.category == selectedCategory, p.listingType == selectedListingType else { return false }
            guard filters.includeInactive || p.status.isActive else { return false }
            if !query.isEmpty {
                let matches = [p.title, p.address, p.city, p.state, p.zipcode]
                    .contains { $0.lowercased().contains(query) }
                guard matches else { return false }
            }
            guard p.price >= filters.minPrice, p.price <= filters.maxPrice else { return false }
            guard p.bedrooms >= filters.minBedrooms, p.bathrooms >= filters.minBathrooms else { return false }
            if filters.ownerFinancingOnly && !p.hasOwnerFinancing { return false }
            return true
        }
    }

    /// Hot Deals para el carrusel: las disponibles más económicas del filtro actual
    func hotDealsProperties(from filtered: [Property]) -> [Property] {
        Array(
            filtered
                .filter { $0.status == .available && $0.price > 0 }
                .sorted { $0.price < $1.price }
                .prefix(15)
        )
    }

    /// Simula carga inicial (para skeleton)
    func loadListings() {
        guard isLoadingListings else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.isLoadingListings = false
        }
    }
}
