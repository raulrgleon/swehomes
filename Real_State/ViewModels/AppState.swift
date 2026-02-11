//
//  AppState.swift
//  Real_State
//
//  Estado global (favoritos, búsquedas, filtros) inyectado vía EnvironmentObject.
//

import Foundation
import SwiftUI

/// Estado compartido de la app: favoritos, historial de búsqueda y filtros
final class AppState: ObservableObject {
    /// IDs de propiedades guardadas como favoritos
    @Published var savedPropertyIds: Set<UUID> = []
    
    /// Historial de búsquedas recientes (últimas 10)
    @Published var searchHistory: [String] = []
    private let maxSearchHistory = 10

    func isSaved(_ propertyId: UUID) -> Bool {
        savedPropertyIds.contains(propertyId)
    }

    func toggleSaved(_ propertyId: UUID) {
        if savedPropertyIds.contains(propertyId) {
            savedPropertyIds.remove(propertyId)
        } else {
            savedPropertyIds.insert(propertyId)
        }
    }

    /// Propiedades guardadas (resolviendo desde mock data)
    func savedProperties(from all: [Property]) -> [Property] {
        all.filter { savedPropertyIds.contains($0.id) }
    }
    
    func addSearchHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        searchHistory.removeAll { $0.lowercased() == trimmed.lowercased() }
        searchHistory.insert(trimmed, at: 0)
        if searchHistory.count > maxSearchHistory {
            searchHistory = Array(searchHistory.prefix(maxSearchHistory))
        }
    }
}
