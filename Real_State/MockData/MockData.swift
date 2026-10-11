//
//  MockData.swift
//  Real_State
//
//  Datos fijos de la app: contacto de la oficina, perfil local y opciones de ajustes.
//

import Foundation
import CoreLocation

enum MockData {

    /// Contacto público de SWE Homes (swehomes.com/contact-us, "Call or Text")
    static let officeContact = Agent(
        id: UUID(uuidString: "a1b2c3d4-0001-4000-8000-000000000001")!,
        name: "SWE Homes Sales Team",
        company: "SWE Homes",
        phone: "+1 (713) 413-1000",
        officeAddress: "6101 Southwest Fwy, Suite 400, Houston, TX 77057",
        website: "https://swehomes.com"
    )

    static let agents: [Agent] = [officeContact]

    /// Centro del mapa: Houston, TX
    static let houstonCenter = CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698)

    /// Propiedades reales desde export.csv (PropertyCSVData.properties)
    static var properties: [Property] { PropertyCSVData.properties }

    static let userProfile = UserProfile(
        name: "SWE Homes Guest",
        avatarEmoji: "👤"
    )

    static let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Notifications", systemImage: "bell.fill")
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
