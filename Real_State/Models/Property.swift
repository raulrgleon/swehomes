//
//  Property.swift
//  Real_State
//
//  Modelo de inmueble para listados y detalle.
//

import Foundation
import CoreLocation

/// Tipo de listado: arrendamiento o venta
enum ListingType: String, CaseIterable, Identifiable {
    case lease = "Lease"
    case sale = "Sale"
    var id: String { rawValue }
}

/// Categoría de propiedad: residencial, comercial o terreno
enum PropertyCategory: String, CaseIterable, Identifiable {
    case residential = "Residential"
    case commercial = "Commercial"
    case land = "Land"
    var id: String { rawValue }
}

/// Estado del anuncio según swehomes.com (columna property_status del CSV)
enum ListingStatus: String, CaseIterable {
    case available = "Available"
    case salePending = "Sale Pending"
    case sold = "Sold"
    case leased = "Leased"
    case unavailable = "Unavailable"

    /// Disponible o en proceso: se muestra por defecto en los listados
    var isActive: Bool { self == .available || self == .salePending }
}

/// Tipo de propiedad (casa, apartamento, etc.)
enum PropertyType: String, CaseIterable {
    case house = "House"
    case apartment = "Apartment"
    case condo = "Condo"
    case townhouse = "Townhouse"
    case office = "Office"
    case retail = "Retail"
    case lot = "Lot"
}

/// Modelo principal de propiedad
struct Property: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var address: String
    var city: String
    var state: String
    var price: Int
    var bedrooms: Int
    var bathrooms: Double
    var squareFeet: Int
    var listingType: ListingType
    var category: PropertyCategory
    var propertyType: PropertyType
    var description: String
    var amenities: [String]
    var coordinate: CLLocationCoordinate2D
    var agentId: UUID
    var status: ListingStatus
    var zipcode: String
    var lotSize: Int?
    /// Financiación directa del propietario (enganche y cuota mensual publicados)
    var downPayment: Int?
    var monthlyPayment: Int?
    /// Ficha original en swehomes.com
    var sourceURL: String?
    /// Índice para gradiente/emoji de imagen fake (0...5). Si imageName no es nil, se usa la imagen real.
    var imageStyleIndex: Int
    /// Nombre del asset de imagen (ej: "PropertyHouse"). Si nil, se usa placeholder.
    var imageName: String? = nil
    /// Múltiples imágenes para carrusel. Si nil, se usa imageName. Si vacío, placeholder.
    var imageNames: [String]? = nil
    /// URLs de imágenes remotas (para datos de CSV/API). Si presente, se usa AsyncImage.
    var imageURLs: [String]? = nil

    var fullAddress: String {
        address.localizedCaseInsensitiveContains(city) ? address : "\(address), \(city), \(state)"
    }
    var priceFormatted: String {
        guard price > 0 else { return "Price on request" }
        return listingType == .lease ? "\(Self.currency(price))/mo" : Self.currency(price)
    }
    var hasOwnerFinancing: Bool { (monthlyPayment ?? 0) > 0 }

    static func currency(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: value)) ?? "$\(value)"
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Coordenadas para uso en SwiftUI (CLLocationCoordinate2D no es Hashable)
struct PropertyCoordinate: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
}
