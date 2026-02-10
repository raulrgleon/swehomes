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
                Annotation(property.address, coordinate: property.coordinate) {
                    MapPinView(isSelected: selectedPropertyId == property.id) {
                        selectedPropertyId = property.id
                    }
                }
                .tag(property.id)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .onAppear {
            position = .region(houstonRegion)
        }
    }
}

private struct MapPinView: View {
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundStyle(isSelected ? .red : .blue)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MapPreviewView(properties: MockData.properties, selectedPropertyId: .constant(nil))
        .frame(height: 300)
}
