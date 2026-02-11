//
//  AppTheme.swift
//  Real_State
//
//  Brand colors and theme for SWE Homes.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Estilo para filas de Settings con feedback visual al tocar
struct SettingsRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .background(configuration.isPressed ? Color(.systemGray5) : Color.clear)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}


enum AppTheme {
    /// SWE Homes brand yellow (from swehomes.com)
    static let accent = Color(red: 0.95, green: 0.85, blue: 0.0)
    static let accentDark = Color(red: 0.85, green: 0.75, blue: 0.0)
    
    /// Hot Deals accent
    static let hotOrange = Color(red: 1.0, green: 0.45, blue: 0.2)
    
    /// Sombras suaves para tarjetas
    static let cardShadow = Color.black.opacity(0.08)
    static let cardShadowRadius: CGFloat = 12
}
