//
//  SkeletonView.swift
//  Real_State
//
//  Placeholder animado para carga de contenido.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(
                LinearGradient(
                    colors: [
                        Color(.systemGray5),
                        Color(.systemGray4)
                    ],
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear { isAnimating = true }
    }
}

struct SkeletonPropertyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SkeletonView()
                .frame(height: 160)
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView()
                    .frame(width: 100, height: 20)
                SkeletonView()
                    .frame(width: 180, height: 14)
                SkeletonView()
                    .frame(width: 140, height: 12)
            }
            .padding(12)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    SkeletonPropertyCard()
        .padding()
}
