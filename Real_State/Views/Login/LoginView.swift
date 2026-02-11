//
//  LoginView.swift
//  Real_State
//
//  Pantalla de inicio de sesión con opciones Google y Apple.
//  (Sign in with Apple real requiere cuenta Apple Developer de pago; aquí se simula para equipo personal.)
//

import SwiftUI

struct LoginView: View {
    var onLogin: () -> Void
    @State private var isSigningIn = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.18),
                    Color(red: 0.08, green: 0.12, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 60)

                Image(systemName: "house.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.white.opacity(0.95))
                Text("SWE Homes")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.top, 16)
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.top, 8)

                Spacer(minLength: 48)

                VStack(spacing: 14) {
                    Button(action: {
                        isSigningIn = true
                        onLogin()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "apple.logo")
                                .font(.title2)
                            Text("Continue with Apple")
                                .font(.headline)
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(isSigningIn)

                    Button(action: {
                        isSigningIn = true
                        onLogin()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "g.circle.fill")
                                .font(.title2)
                            Text("Continue with Google")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(red: 0.26, green: 0.52, blue: 0.96), in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(isSigningIn)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
}

#Preview {
    LoginView(onLogin: {})
}
