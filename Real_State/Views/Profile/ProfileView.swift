//
//  ProfileView.swift
//  Real_State
//
//  Pestaña Profile: avatar, nombre, búsquedas recientes, opciones de configuración.
//

import SwiftUI

struct ProfileView: View {
    private let profile = MockData.userProfile
    private let settings = MockData.settingsItems

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    recentSearchesSection
                    settingsSection
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("SWE Homes")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text(profile.avatarEmoji)
                .font(.system(size: 72))
                .frame(width: 100, height: 100)
                .background(
                    LinearGradient(
                        colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            Text(profile.name)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.secondarySystemGroupedBackground))
    }

    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently searched")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 0) {
                ForEach(Array(profile.recentlySearchedLocations.enumerated()), id: \.offset) { _, location in
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                            .frame(width: 24, alignment: .center)
                        Text(location)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    if location != profile.recentlySearchedLocations.last {
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 0) {
                ForEach(settings) { item in
                    HStack {
                        Image(systemName: item.systemImage)
                            .foregroundStyle(.blue)
                            .frame(width: 28, alignment: .center)
                        Text(item.title)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    if item.id != settings.last?.id {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
}
