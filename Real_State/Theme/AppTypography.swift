//
//  AppTypography.swift
//  Real_State
//
//  Tipografía con jerarquía y personalidad para SWE Homes.
//

import SwiftUI

extension Font {
    /// Títulos principales - serif para elegancia inmobiliaria
    static let appTitle = Font.system(.title, design: .serif).weight(.bold)
    static let appTitle2 = Font.system(.title2, design: .serif).weight(.semibold)
    static let appTitle3 = Font.system(.title3, design: .serif).weight(.semibold)
    /// Headlines - rounded para cercanía
    static let appHeadline = Font.system(.headline, design: .rounded).weight(.semibold)
    static let appSubheadline = Font.system(.subheadline, design: .rounded)
    /// Body - system default
    static let appBody = Font.subheadline
    static let appCaption = Font.caption
}
