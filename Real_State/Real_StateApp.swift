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

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
            } else {
                OnboardingView(onComplete: { hasSeenOnboarding = true })
            }
        }
    }
}
