//
//  AppState.swift
//  Real_State
//
//  Estado global (favoritos, filtros) inyectado vía EnvironmentObject.
//

import Foundation
import SwiftUI

/// Estado compartido de la app: favoritos y filtros aplicados
final class AppState: ObservableObject {
    /// IDs de propiedades guardadas como favoritos
    @Published var savedPropertyIds: Set<UUID> = []

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
}
