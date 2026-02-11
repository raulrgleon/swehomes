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

    /// Propiedades reales desde export.csv (PropertyCSVData.properties)
    static var properties: [Property] { PropertyCSVData.properties }

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
