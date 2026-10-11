//
//  UserProfile.swift
//  Real_State
//
//  Modelo de perfil de usuario para la pestaña Profile.
//

import Foundation

struct UserProfile {
    var name: String
    var avatarEmoji: String
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
}
