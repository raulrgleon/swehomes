//
//  PropertyCardView.swift
//  Real_State
//
//  Tarjeta de propiedad para listados: imagen, precio, beds/baths, ubicación, favorito.
//

import SwiftUI
import MapKit
import UIKit

struct PropertyCardView: View {
    let property: Property
    let isSaved: Bool
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Group {
                        if let name = property.imageName {
                            Image(name)
                                .resizable()
                                .scaledToFill()
                        } else {
                            HeroPlaceholderView(styleIndex: property.imageStyleIndex)
                        }
                    }
                    .frame(height: 160)
                    .clipped()
                    HStack(spacing: 6) {
                        if property.isNewListing {
                            tag("New", color: .green)
                        }
                        if property.isOpenHouse {
                            tag("Open House", color: .orange)
                        }
                    }
                    .padding(8)
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onFavorite()
                    }) {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .accessibilityLabel(isSaved ? "Remove from saved" : "Save property")
                            .font(.title3)
                            .foregroundStyle(isSaved ? .red : .white)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                    }
                    .buttonStyle(.plain)
                    .padding(8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(property.priceFormatted)
                        .font(.appHeadline)
                        .foregroundStyle(.primary)
                    if property.bedrooms > 0 || property.bathrooms > 0 || property.squareFeet > 0 {
                        HStack(spacing: 16) {
                            if property.bedrooms > 0 {
                                label(icon: "bed.double.fill", text: "\(property.bedrooms)")
                            }
                            if property.bathrooms > 0 {
                                label(icon: "drop.fill", text: formatBaths(property.bathrooms))
                            }
                            if property.squareFeet > 0 {
                                label(icon: "square.foot", text: "\(property.squareFeet)")
                            }
                        }
                        .font(.appSubheadline)
                        .foregroundStyle(.secondary)
                    }
                    Text(property.fullAddress)
                        .font(.appCaption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text("\(property.category.rawValue) • \(property.listingType.rawValue)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(12)
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: AppTheme.cardShadow, radius: AppTheme.cardShadowRadius, x: 0, y: 6)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private func tag(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }

    private func label(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
        }
    }

    private func formatBaths(_ n: Double) -> String {
        n == floor(n) ? "\(Int(n))" : String(format: "%.1f", n)
    }
}

#Preview {
    PropertyCardView(
        property: MockData.properties[0],
        isSaved: false,
        onTap: {},
        onFavorite: {}
    )
    .padding()
}
