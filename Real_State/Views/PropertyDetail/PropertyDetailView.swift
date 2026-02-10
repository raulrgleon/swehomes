//
//  PropertyDetailView.swift
//  Real_State
//
//  Pantalla de detalle: hero, carrusel fake, precio, datos, descripción, amenities, agente, CTAs.
//

import SwiftUI
import MapKit

struct PropertyDetailView: View {
    let property: Property
    @EnvironmentObject var appState: AppState
    @State private var selectedImageIndex = 0
    @Environment(\.dismiss) private var dismiss

    private var agent: Agent? {
        MockData.agents.first { $0.id == property.agentId }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSection
                priceAndStatsSection
                descriptionSection
                amenitiesSection
                if let agent = agent {
                    agentCard(agent)
                }
                mapPreviewSection
                ctaButtonsSection
            }
            .padding(.bottom, 32)
        }
        .navigationTitle(property.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.toggleSaved(property.id)
                } label: {
                    Image(systemName: appState.isSaved(property.id) ? "heart.fill" : "heart")
                        .foregroundStyle(appState.isSaved(property.id) ? .red : .primary)
                }
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<3, id: \.self) { index in
                    HeroPlaceholderView(styleIndex: (property.imageStyleIndex + index) % 6, cornerRadius: 0)
                        .frame(height: 280)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 280)
            .overlay(alignment: .bottom) {
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(selectedImageIndex == i ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }

    private var priceAndStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(property.priceFormatted)
                .font(.title)
                .fontWeight(.bold)
            Text(property.fullAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("\(property.category.rawValue) • \(property.listingType.rawValue)")
                .font(.caption)
                .foregroundStyle(.tertiary)
            if property.bedrooms > 0 || property.bathrooms > 0 || property.squareFeet > 0 {
                HStack(spacing: 24) {
                    if property.bedrooms > 0 {
                        stat(icon: "bed.double.fill", value: "\(property.bedrooms)", label: "Beds")
                    }
                    if property.bathrooms > 0 {
                        stat(icon: "drop.fill", value: formatBaths(property.bathrooms), label: "Baths")
                    }
                    if property.squareFeet > 0 {
                        stat(icon: "square.foot", value: "\(property.squareFeet)", label: "Sq ft")
                    }
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private func stat(icon: String, value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .fontWeight(.medium)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
            Text(property.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amenities")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                ForEach(property.amenities, id: \.self) { amenity in
                    HStack(spacing: 8) {
                        Image(systemName: amenityIcon(amenity))
                            .foregroundStyle(.blue)
                        Text(amenity)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private func amenityIcon(_ name: String) -> String {
        switch name.lowercased() {
        case "parking": return "car.fill"
        case "gym": return "dumbbell.fill"
        case "rooftop": return "building.2.fill"
        case "doorman": return "person.fill"
        case "storage": return "archivebox.fill"
        case "garden": return "leaf.fill"
        case "garage": return "car.fill"
        case "ac": return "snowflake"
        case "fireplace": return "flame.fill"
        case "water view": return "water.waves"
        case "balcony": return "square.arrow.up"
        case "concierge": return "person.badge.key.fill"
        case "patio": return "sun.max.fill"
        case "laundry": return "washer.fill"
        case "bike storage": return "bicycle"
        case "elevator": return "arrow.up.arrow.down"
        case "wine cellar": return "wineglass.fill"
        default: return "checkmark.circle.fill"
        }
    }

    private func agentCard(_ agent: Agent) -> some View {
        HStack(spacing: 16) {
            Text("👤")
                .font(.system(size: 44))
                .frame(width: 56, height: 56)
                .background(Color(.tertiarySystemBackground))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text(agent.name)
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", agent.rating))
                        .font(.subheadline)
                    Text("(\(agent.reviewCount) reviews)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(agent.company)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var mapPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.headline)
                .padding(.horizontal)
            MapPreviewView(properties: [property], selectedPropertyId: .constant(property.id))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
        }
    }

    private var ctaButtonsSection: some View {
        VStack(spacing: 12) {
            Button {
                // Contact Agent - mock
            } label: {
                Label("Contact Agent", systemImage: "message.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
            Button {
                // Schedule Tour - mock
            } label: {
                Label("Schedule Tour", systemImage: "calendar")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal)
    }

    private func formatBaths(_ n: Double) -> String {
        n == floor(n) ? "\(Int(n))" : String(format: "%.1f", n)
    }
}

#Preview {
    NavigationStack {
        PropertyDetailView(property: MockData.properties[0])
            .environmentObject(AppState())
    }
}
