//
//  AppState.swift
//  Real_State
//
//  Estado global (favoritos, búsquedas) inyectado vía EnvironmentObject y persistido en UserDefaults.
//

import Foundation
import SwiftUI

/// Estado compartido de la app: favoritos e historial de búsqueda
final class AppState: ObservableObject {
    private enum Keys {
        static let savedPropertyIds = "savedPropertyIds"
        static let searchHistory = "searchHistory"
    }

    private let defaults: UserDefaults

    /// IDs de propiedades guardadas como favoritos
    @Published var savedPropertyIds: Set<UUID> {
        didSet { defaults.set(savedPropertyIds.map(\.uuidString), forKey: Keys.savedPropertyIds) }
    }

    /// Historial de búsquedas recientes (últimas 10)
    @Published var searchHistory: [String] {
        didSet { defaults.set(searchHistory, forKey: Keys.searchHistory) }
    }
    private let maxSearchHistory = 10

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let ids = defaults.stringArray(forKey: Keys.savedPropertyIds) ?? []
        savedPropertyIds = Set(ids.compactMap(UUID.init(uuidString:)))
        searchHistory = defaults.stringArray(forKey: Keys.searchHistory) ?? []
    }

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

    func savedProperties(from all: [Property]) -> [Property] {
        all.filter { savedPropertyIds.contains($0.id) }
    }

    func addSearchHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var history = searchHistory
        history.removeAll { $0.lowercased() == trimmed.lowercased() }
        history.insert(trimmed, at: 0)
        searchHistory = Array(history.prefix(maxSearchHistory))
    }

    func clearSearchHistory() {
        searchHistory = []
    }
}
