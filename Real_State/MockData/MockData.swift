//
//  MockData.swift
//  Real_State
//
//  Datos locales para el prototipo offline.
//

import Foundation
import CoreLocation
import MapKit

enum MockData {

    static let agents: [Agent] = [
        Agent(id: UUID(uuidString: "a1b2c3d4-0001-4000-8000-000000000001")!,
              name: "Sarah Mitchell",
              rating: 4.9,
              reviewCount: 127,
              company: "Premier Realty",
              phone: "+1 (555) 123-4567",
              email: "sarah.mitchell@premierrealty.com"),
        Agent(id: UUID(uuidString: "a1b2c3d4-0002-4000-8000-000000000002")!,
              name: "James Chen",
              rating: 4.8,
              reviewCount: 89,
              company: "Urban Homes",
              phone: "+1 (555) 234-5678",
              email: "james.chen@urbanhomes.com"),
        Agent(id: UUID(uuidString: "a1b2c3d4-0003-4000-8000-000000000003")!,
              name: "Emily Rodriguez",
              rating: 5.0,
              reviewCount: 64,
              company: "Luxury Estates",
              phone: "+1 (555) 345-6789",
              email: "emily.r@luxuryestates.com")
    ]

    /// Centro del mapa: Houston, TX
    static let houstonCenter = CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698)

    static let properties: [Property] = [
        Property(
            id: UUID(uuidString: "b2c3d4e5-0001-4000-8000-000000000001")!,
            title: "Modern Downtown Loft",
            address: "1245 Main St",
            city: "Houston",
            state: "TX",
            price: 1_250_000,
            bedrooms: 2,
            bathrooms: 2,
            squareFeet: 1450,
            listingType: .sale,
            category: .residential,
            propertyType: .condo,
            description: "Stunning loft with floor-to-ceiling windows and open floor plan. High-end finishes throughout. Walking distance to restaurants and transit.",
            amenities: ["Parking", "Gym", "Rooftop", "Doorman", "Storage"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698), // Downtown
            agentId: agents[0].id,
            isNewListing: true,
            isOpenHouse: true,
            imageStyleIndex: 0
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0002-4000-8000-000000000002")!,
            title: "Family Home with Garden",
            address: "789 Oak Avenue",
            city: "Houston",
            state: "TX",
            price: 2_850_000,
            bedrooms: 4,
            bathrooms: 3.5,
            squareFeet: 2800,
            listingType: .sale,
            category: .residential,
            propertyType: .house,
            description: "Spacious family home on a quiet street. Updated kitchen, large backyard, and excellent schools nearby.",
            amenities: ["Garden", "Garage", "AC", "Fireplace"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7950, longitude: -95.4690), // Heights
            agentId: agents[1].id,
            isNewListing: false,
            isOpenHouse: false,
            imageStyleIndex: 1
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0003-4000-8000-000000000003")!,
            title: "Waterfront Condo",
            address: "456 Harbor Dr",
            city: "Houston",
            state: "TX",
            price: 3_200_000,
            bedrooms: 3,
            bathrooms: 3,
            squareFeet: 2200,
            listingType: .lease,
            category: .residential,
            propertyType: .condo,
            description: "Breathtaking bay views from every room. Premium building with concierge and private deck.",
            amenities: ["Water View", "Balcony", "Gym", "Parking", "Concierge"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7354, longitude: -95.4100), // Midtown
            agentId: agents[2].id,
            isNewListing: true,
            isOpenHouse: false,
            imageStyleIndex: 2
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0004-4000-8000-000000000004")!,
            title: "Cozy Townhouse",
            address: "321 Elm Street",
            city: "Houston",
            state: "TX",
            price: 1_100_000,
            bedrooms: 3,
            bathrooms: 2,
            squareFeet: 1650,
            listingType: .sale,
            category: .residential,
            propertyType: .townhouse,
            description: "Charming townhouse steps from cafes and parks. Recently renovated with modern appliances.",
            amenities: ["Patio", "Garage", "AC"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7180, longitude: -95.4200), // Museum District
            agentId: agents[0].id,
            isNewListing: false,
            isOpenHouse: true,
            imageStyleIndex: 3
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0005-4000-8000-000000000005")!,
            title: "Galleria Office Space",
            address: "5000 Westheimer Rd",
            city: "Houston",
            state: "TX",
            price: 4_500_000,
            bedrooms: 0,
            bathrooms: 4.5,
            squareFeet: 3800,
            listingType: .sale,
            category: .commercial,
            propertyType: .office,
            description: "Exceptional office space with 360° city views. Private elevator, conference rooms, and rooftop terrace.",
            amenities: ["Rooftop", "Elevator", "Parking", "Doorman", "Fiber"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7374, longitude: -95.4624), // Galleria
            agentId: agents[2].id,
            isNewListing: true,
            isOpenHouse: false,
            imageStyleIndex: 4
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0006-4000-8000-000000000006")!,
            title: "Sunny Apartment for Rent",
            address: "555 Midtown Blvd",
            city: "Houston",
            state: "TX",
            price: 3_200,
            bedrooms: 2,
            bathrooms: 1,
            squareFeet: 950,
            listingType: .lease,
            category: .residential,
            propertyType: .apartment,
            description: "Bright and airy apartment in the heart of Midtown. Pet-friendly building.",
            amenities: ["Laundry", "Bike Storage"],
            coordinate: CLLocationCoordinate2D(latitude: 29.6200, longitude: -95.6350), // Sugar Land
            agentId: agents[1].id,
            isNewListing: false,
            isOpenHouse: false,
            imageStyleIndex: 5
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0007-4000-8000-000000000007")!,
            title: "Retail Corner Unit",
            address: "2100 Post Oak Blvd",
            city: "Houston",
            state: "TX",
            price: 1_850_000,
            bedrooms: 0,
            bathrooms: 2,
            squareFeet: 2200,
            listingType: .lease,
            category: .commercial,
            propertyType: .retail,
            description: "High-traffic corner retail space. Great visibility and parking.",
            amenities: ["Parking", "Storefront", "AC"],
            coordinate: CLLocationCoordinate2D(latitude: 29.7284, longitude: -95.4614), // Post Oak
            agentId: agents[0].id,
            isNewListing: false,
            isOpenHouse: false,
            imageStyleIndex: 0
        ),
        Property(
            id: UUID(uuidString: "b2c3d4e5-0008-4000-8000-000000000008")!,
            title: "Developable Land - Cypress",
            address: "18000 FM 529",
            city: "Houston",
            state: "TX",
            price: 890_000,
            bedrooms: 0,
            bathrooms: 0,
            squareFeet: 0,
            listingType: .sale,
            category: .land,
            propertyType: .lot,
            description: "2.5 acre lot ready for development. Utilities available. Zoned for mixed use.",
            amenities: ["Utilities", "Highway Access"],
            coordinate: CLLocationCoordinate2D(latitude: 29.9684, longitude: -95.6898), // Cypress
            agentId: agents[1].id,
            isNewListing: true,
            isOpenHouse: false,
            imageStyleIndex: 1
        )
    ]

    static let userProfile = UserProfile(
        name: "Alex Johnson",
        avatarEmoji: "👤",
        recentlySearchedLocations: ["Houston, TX", "The Woodlands, TX", "Katy, TX", "Sugar Land, TX"]
    )

    static let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Notifications", systemImage: "bell.fill"),
        SettingsItem(title: "Privacy", systemImage: "lock.fill"),
        SettingsItem(title: "Payment Methods", systemImage: "creditcard.fill"),
        SettingsItem(title: "Help & Support", systemImage: "questionmark.circle.fill"),
        SettingsItem(title: "About", systemImage: "info.circle.fill")
    ]

    /// Gradientes para imágenes fake por índice
    static let heroGradientColors: [[String]] = [
        ["#1a1a2e", "#16213e"],
        ["#2d132c", "#801336"],
        ["#0f3460", "#16213e"],
        ["#1b262c", "#0f3460"],
        ["#2c3e50", "#3498db"],
        ["#e74c3c", "#c0392b"]
    ]
}
