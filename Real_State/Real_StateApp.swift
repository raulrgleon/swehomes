//
//  Real_StateApp.swift
//  Real_State
//
//  Punto de entrada de la aplicación.
//

import SwiftUI

@main
struct Real_StateApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hotDealsNotificationsEnabled") private var hotDealsNotificationsEnabled = true

    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView(onComplete: { hasSeenOnboarding = true })
            } else if !isLoggedIn {
                LoginView(onLogin: { isLoggedIn = true })
            } else {
                ContentView()
                    .onAppear {
                        if hotDealsNotificationsEnabled {
                            HotDealsNotificationService.shared.setupHotDealsNotifications()
                        }
                    }
            }
        }
    }
}
