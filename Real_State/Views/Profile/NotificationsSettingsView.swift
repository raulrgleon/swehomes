//
//  NotificationsSettingsView.swift
//  Real_State
//
//  Vista de configuración de notificaciones dentro de Settings.
//

import SwiftUI
import UserNotifications

struct NotificationsSettingsView: View {
    @AppStorage("hotDealsNotificationsEnabled") private var hotDealsNotificationsEnabled = true
    @AppStorage("schedule1Min") private var schedule1Min = false
    @AppStorage("schedule5Min") private var schedule5Min = false
    @AppStorage("schedule1Hour") private var schedule1Hour = false
    @AppStorage("schedule6Hours") private var schedule6Hours = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "bell.badge.fill")
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 28, alignment: .center)
                Text("Hot Deals Notifications")
                    .font(.subheadline)
                Spacer()
                Toggle("", isOn: hotDealsBinding)
                    .labelsHidden()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemGroupedBackground))
            Divider()
                .padding(.leading, 44)
            scheduleToggle("1 minute", id: HotDealsNotificationService.testIds.oneMin, seconds: 60, storage: $schedule1Min)
            Divider().padding(.leading, 44)
            scheduleToggle("5 minutes", id: HotDealsNotificationService.testIds.fiveMin, seconds: 300, storage: $schedule5Min)
            Divider().padding(.leading, 44)
            scheduleToggle("1 hour", id: HotDealsNotificationService.testIds.oneHour, seconds: 3600, storage: $schedule1Hour)
            Divider().padding(.leading, 44)
            scheduleToggle("6 hours", id: HotDealsNotificationService.testIds.sixHours, seconds: 21600, storage: $schedule6Hours)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hotDealsBinding: Binding<Bool> {
        Binding(
            get: { hotDealsNotificationsEnabled },
            set: { enabled in
                hotDealsNotificationsEnabled = enabled
                if enabled {
                    HotDealsNotificationService.shared.setupHotDealsNotifications()
                } else {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["hot-deals-morning", "hot-deals-afternoon"])
                }
            }
        )
    }

    private func scheduleToggle(_ label: String, id: String, seconds: TimeInterval, storage: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: "clock.badge.checkmark")
                .foregroundStyle(AppTheme.accent)
                .frame(width: 28, alignment: .center)
            Text(label)
                .font(.subheadline)
            Spacer()
            Toggle("", isOn: Binding(
                get: { storage.wrappedValue },
                set: { enabled in
                    storage.wrappedValue = enabled
                    if enabled {
                        HotDealsNotificationService.shared.scheduleTestNotification(id: id, in: seconds)
                    } else {
                        HotDealsNotificationService.shared.cancelTestNotification(id: id)
                    }
                }
            ))
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView()
    }
}
