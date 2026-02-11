//
//  OnboardingView.swift
//  Real_State
//
//  Tres pantallas de bienvenida con información de SWE Homes (swehomes.com).
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let subtitle: String
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        id: 0,
        icon: "house.fill",
        title: "Owner Finance Real Estate",
        subtitle: "SWE Homes offers homes, commercial properties, and land for sale with owner financing options across Texas."
    ),
    OnboardingPage(
        id: 1,
        icon: "building.2.fill",
        title: "Residential, Commercial & Land",
        subtitle: "Browse new listings, recent renovations, featured commercial properties, and land spotlight—all in one place."
    ),
    OnboardingPage(
        id: 2,
        icon: "magnifyingglass",
        title: "Search & Save Properties",
        subtitle: "Find your next property, save favorites, view on the map, and contact agents directly. Get started today."
    )
]

struct OnboardingView: View {
    var onComplete: () -> Void
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.09, blue: 0.2),
                    Color(red: 0.12, green: 0.15, blue: 0.28)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            GeometryReader { geo in
                Circle()
                    .fill(AppTheme.accent.opacity(0.06))
                    .frame(width: 280, height: 280)
                    .blur(radius: 80)
                    .offset(x: geo.size.width * 0.4, y: -80)
            }

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    } else {
                        Color.clear
                            .frame(height: 48)
                            .padding(.horizontal, 20)
                    }
                }

                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        onboardingPageView(page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.25), value: currentPage)

                pageIndicator
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) { currentPage += 1 }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.appHeadline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [AppTheme.accent, AppTheme.accentDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }

    private func onboardingPageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 32) {
            Spacer(minLength: 40)
                Image(systemName: page.icon)
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.9)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 6)

            VStack(spacing: 16) {
                Text(page.title)
                    .font(.appTitle2)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            Spacer(minLength: 80)
        }
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.35))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
