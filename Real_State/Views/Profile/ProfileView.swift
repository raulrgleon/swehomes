//
//  ProfileView.swift
//  Real_State
//
//  Pestaña Profile: avatar, nombre, búsquedas recientes, opciones de configuración.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    private let profile = MockData.userProfile
    private let settings = MockData.settingsItems
    
    private var recentSearches: [String] {
        !appState.searchHistory.isEmpty ? appState.searchHistory : profile.recentlySearchedLocations
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    recentSearchesSection
                    settingsSection
                    logoutSection
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
                ForEach(Array(recentSearches.enumerated()), id: \.offset) { _, location in
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
                    if location != recentSearches.last {
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
                    Group {
                        if item.title == "Notifications" {
                            NavigationLink {
                                NotificationsSettingsView()
                            } label: {
                                HStack {
                                    Image(systemName: item.systemImage)
                                        .foregroundStyle(AppTheme.accent)
                                        .frame(width: 28, alignment: .center)
                                    Text(item.title)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.secondarySystemGroupedBackground))
                        } else {
                            HStack {
                                Image(systemName: item.systemImage)
                                    .foregroundStyle(AppTheme.accent)
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
                        }
                    }
                    if item.id != settings.last?.id {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
                Button {
                    hasSeenOnboarding = false
                } label: {
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .foregroundStyle(AppTheme.accent)
                            .frame(width: 28, alignment: .center)
                        Text("View onboarding again")
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }

    private var logoutSection: some View {
        Button {
            isLoggedIn = false
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.red)
                Text("Log out")
                    .font(.headline)
                    .foregroundStyle(.red)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
