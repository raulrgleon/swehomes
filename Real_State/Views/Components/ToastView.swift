//
//  ToastView.swift
//  Real_State
//
//  Mensaje breve de confirmación que aparece y desaparece.
//

import SwiftUI

struct ToastView: View {
    let message: String
    var icon: String = "checkmark.circle.fill"

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.white)
            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .background(AppTheme.accent.opacity(0.9))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var message: String?
    let duration: Double

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let msg = message {
                    ToastView(message: msg)
                        .padding(.top, 60)
                        .zIndex(100)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    message = nil
                                }
                            }
                        }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: message)
    }
}

extension View {
    func toast(message: Binding<String?>, duration: Double = 2.5) -> some View {
        modifier(ToastModifier(message: message, duration: duration))
    }
}
