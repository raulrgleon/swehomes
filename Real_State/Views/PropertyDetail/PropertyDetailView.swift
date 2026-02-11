//
//  PropertyDetailView.swift
//  Real_State
//
//  Pantalla de detalle: hero, carrusel fake, precio, datos, descripción, amenities, agente, CTAs.
//

import SwiftUI
import MapKit
import MessageUI

struct PropertyDetailView: View {
    let property: Property
    @EnvironmentObject var appState: AppState
    @State private var selectedImageIndex = 0
    @State private var isFullscreenImagePresented = false
    @State private var toastMessage: String?
    @Environment(\.dismiss) private var dismiss

    private let heroHeight: CGFloat = 340

    private var fullscreenImageNames: [String]? {
        if let names = property.imageNames, !names.isEmpty { return names }
        if let name = property.imageName { return [name] }
        return nil
    }

    private var agent: Agent? {
        MockData.agents.first { $0.id == property.agentId }
    }

    private var similarProperties: [Property] {
        PropertyRepository.shared.similarProperties(to: property)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSectionWithParallax
                priceAndStatsSection
                descriptionSection
                amenitiesSection
                mapPreviewSection
                ctaButtonsSection
                if !similarProperties.isEmpty {
                    similarPropertiesSection
                }
            }
            .padding(.bottom, 32)
        }
        .navigationTitle(property.title)
        .navigationBarTitleDisplayMode(.inline)
        .toast(message: $toastMessage)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    appState.toggleSaved(property.id)
                    toastMessage = appState.isSaved(property.id) ? "Saved to favorites" : "Removed from favorites"
                } label: {
                    Image(systemName: appState.isSaved(property.id) ? "heart.fill" : "heart")
                        .foregroundStyle(appState.isSaved(property.id) ? .red : .primary)
                }
            }
        }
    }

    private var heroSectionWithParallax: some View {
        ZStack(alignment: .bottom) {
            heroContent
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .center,
                endPoint: .bottom
            )
            .allowsHitTesting(false)
            pageIndicatorOverlay
            if fullscreenImageNames != nil {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(6)
                    .background(.black.opacity(0.3), in: Circle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(10)
                    .allowsHitTesting(false)
            }
        }
        .frame(height: heroHeight)
        .clipped()
        .contentShape(Rectangle())
        .onTapGesture {
            if fullscreenImageNames != nil {
                isFullscreenImagePresented = true
            }
        }
        .fullScreenCover(isPresented: $isFullscreenImagePresented) {
            if let names = fullscreenImageNames {
                FullscreenImageView(
                    imageNames: names,
                    initialIndex: selectedImageIndex,
                    isPresented: $isFullscreenImagePresented
                )
            }
        }
    }

    @ViewBuilder
    private var heroContent: some View {
        if let names = property.imageNames, !names.isEmpty {
            TabView(selection: $selectedImageIndex) {
                ForEach(Array(names.enumerated()), id: \.offset) { index, name in
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: heroHeight)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        } else if let name = property.imageName {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(height: heroHeight)
                .clipped()
        } else {
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<3, id: \.self) { index in
                    HeroPlaceholderView(styleIndex: (property.imageStyleIndex + index) % 6, cornerRadius: 0)
                        .frame(height: heroHeight)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
    }

    @ViewBuilder
    private var pageIndicatorOverlay: some View {
        if let names = property.imageNames, !names.isEmpty {
            pageIndicator(count: names.count)
        } else if property.imageName == nil {
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

    private var priceAndStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(property.priceFormatted)
                .font(.appTitle2)
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
                .font(.appHeadline)
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
                .font(.appHeadline)
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
        case "2-car garage": return "car.2.fill"
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
        case "loading": return "shippingbox.fill"
        case "storefront": return "storefront.fill"
        case "24h security": return "lock.shield.fill"
        case "kitchen": return "fork.knife"
        case "utilities": return "bolt.fill"
        case "highway access": return "road.lanes"
        case "paved street": return "road.lanes.curved"
        case "water": return "drop.fill"
        case "electricity": return "bolt.fill"
        case "easy access": return "arrow.triangle.turn.up.right.diamond.fill"
        case "lake": return "water.waves"
        case "fenced": return "rectangle.3.group.fill"
        case "pool": return "figure.pool.swim"
        case "lobby": return "door.garage.closed"
        default: return "checkmark.circle.fill"
        }
    }

    private var mapPreviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.appHeadline)
                .padding(.horizontal)
            MapPreviewView(properties: [property], selectedPropertyId: .constant(property.id))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            Button {
                openInMaps()
            } label: {
                Label("Open in Maps", systemImage: "map.fill")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
        }
    }

    private var ctaButtonsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let agent = agent {
                HStack(spacing: 12) {
                    Text("👤")
                        .font(.system(size: 36))
                        .frame(width: 48, height: 48)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(agent.name)
                            .font(.headline)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
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
                    Spacer(minLength: 0)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if let agent = agent, let url = URL(string: "tel:\(agent.phone.filter(\.isNumber))") {
                Button {
                    UIApplication.shared.open(url)
                } label: {
                    Label("Call Agent", systemImage: "phone.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
            }
            if let agent = agent {
                Button {
                    openMessage(agent: agent)
                    toastMessage = "Opening Messages..."
                } label: {
                    Label("Contact Agent", systemImage: "message.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.accent)
            }
            Button {
                shareProperty()
                toastMessage = "Property shared"
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.bordered)
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

    private func pageIndicator(count: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .fill(selectedImageIndex == i ? Color.white : Color.white.opacity(0.5))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.bottom, 12)
    }

    private func openMessage(agent: Agent) {
        let body = "Hi \(agent.name), I'm interested in \(property.title) (\(property.fullAddress)). Could you provide more information?"
        let phone = agent.phone.filter(\.isNumber)
        if MFMessageComposeViewController.canSendText() {
            let vc = MFMessageComposeViewController()
            vc.recipients = [phone]
            vc.body = body
            vc.messageComposeDelegate = MessageComposeDelegate.shared
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = windowScene.windows.first?.rootViewController {
                root.present(vc, animated: true)
            }
        } else if let url = URL(string: "sms:\(phone)") {
            UIApplication.shared.open(url)
        }
    }

    private func openInMaps() {
        let coord = property.coordinate
        let address = property.fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "maps://?ll=\(coord.latitude),\(coord.longitude)&q=\(address)")!
        UIApplication.shared.open(url)
    }

    private func shareProperty() {
        let text = "\(property.title) - \(property.priceFormatted)\n\(property.fullAddress)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }

    private var similarPropertiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Similar Properties")
                .font(.appHeadline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(similarProperties) { p in
                        NavigationLink {
                            PropertyDetailView(property: p)
                                .environmentObject(appState)
                        } label: {
                            similarCard(p)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func similarCard(_ p: Property) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let name = p.imageName {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                } else {
                    HeroPlaceholderView(styleIndex: p.imageStyleIndex)
                }
            }
            .frame(width: 160, height: 100)
            .clipped()
            VStack(alignment: .leading, spacing: 2) {
                Text(p.priceFormatted)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(p.fullAddress)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
        }
        .frame(width: 160)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: AppTheme.cardShadow.opacity(0.5), radius: 6, x: 0, y: 3)
    }

    private func formatBaths(_ n: Double) -> String {
        n == floor(n) ? "\(Int(n))" : String(format: "%.1f", n)
    }
}

// MARK: - Message Delegate

private final class MessageComposeDelegate: NSObject, MFMessageComposeViewControllerDelegate {
    static let shared = MessageComposeDelegate()

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}

#Preview {
    NavigationStack {
        PropertyDetailView(property: MockData.properties[0])
            .environmentObject(AppState())
    }
}
