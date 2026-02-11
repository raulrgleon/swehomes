//
//  PropertyRepository.swift
//  Real_State
//
//  Data layer for properties. Ready for future API integration.
//

import Foundation
import CoreLocation

final class PropertyRepository {
    static let shared = PropertyRepository()
    
    func fetchProperties() -> [Property] {
        MockData.properties
    }
    
    func similarProperties(to property: Property, limit: Int = 3) -> [Property] {
        MockData.properties
            .filter { $0.id != property.id && $0.category == property.category }
            .prefix(limit)
            .map { $0 }
    }
}
