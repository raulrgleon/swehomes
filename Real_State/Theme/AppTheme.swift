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
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: configuration.isPressed)
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
    /// SWE Homes brand yellow (from swehomes.com) but adjusted for contrast
    static let accent = Color(red: 0.95, green: 0.85, blue: 0.0)
    static let accentDark = Color(red: 0.85, green: 0.75, blue: 0.0)
    
    /// True OLED Black for deep backgrounds
    static let trueBlack = Color(white: 0.02)
    
    /// Hot Deals accent (Neon feeling)
    static let hotOrange = Color(red: 1.0, green: 0.3, blue: 0.1)
    
    /// Sombras suaves para tarjetas
    static let cardShadow = Color.black.opacity(0.12)
    static let cardShadowRadius: CGFloat = 16
}
