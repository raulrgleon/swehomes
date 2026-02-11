//
//  MapPreviewView.swift
//  Real_State
//
//  Mapa con pins de propiedades; al tocar un pin se resalta la propiedad.
//

import SwiftUI
import MapKit

struct MapPreviewView: View {
    let properties: [Property]
    @Binding var selectedPropertyId: UUID?
    var defaultCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698)
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?

    /// Región Gran Houston (área metropolitana completa)
    private var houstonRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: defaultCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.45, longitudeDelta: 0.5)
        )
    }

    var body: some View {
        Map(position: $position, selection: $selectedPropertyId) {
            ForEach(properties) { property in
                Annotation(property.title, coordinate: property.coordinate) {
                    MapPinView(
                        isSelected: selectedPropertyId == property.id,
                        category: property.category,
                        price: property.priceFormatted
                    ) {
                        selectedPropertyId = property.id
                    }
                }
                .tag(property.id)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5).opacity(0.5), lineWidth: 1)
        )
        .onAppear {
            position = .region(houstonRegion)
        }
    }
}

private struct MapPinView: View {
    let isSelected: Bool
    let category: PropertyCategory
    let price: String
    let action: () -> Void
    @State private var pulseScale: CGFloat = 1.0

    private var pinColor: Color {
        if isSelected { return AppTheme.hotOrange }
        switch category {
        case .residential: return .blue
        case .commercial: return .purple
        case .land: return .green
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(price)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(pinColor)
                    .clipShape(Capsule())
                    .opacity(isSelected ? 1 : 0.9)
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundStyle(pinColor)
                    .scaleEffect(isSelected ? 1.15 : pulseScale)
            }
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseScale = 1.2
            }
        }
    }
}

#Preview {
    MapPreviewView(properties: PropertyRepository.shared.fetchProperties(), selectedPropertyId: .constant(nil))
        .frame(height: 300)
}
