//
//  FilterSheetView.swift
//  Real_State
//
//  Sheet de filtros: precio, habitaciones, baños, toggles New/Open House.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @Environment(\.dismiss) private var dismiss

    private let priceStep = 100_000
    private var priceRange: ClosedRange<Int> { 0...5_000_000 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Price Range Section
                    filterSection(title: "Price Range") {
                        VStack(spacing: 20) {
                            HStack {
                                Text(formatPrice(viewModel.filters.minPrice))
                                    .font(.headline)
                                Spacer()
                                Text("-")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(formatPrice(viewModel.filters.maxPrice))
                                    .font(.headline)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Min")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Slider(
                                        value: Binding(
                                            get: { Double(viewModel.filters.minPrice) },
                                            set: { viewModel.filters.minPrice = Int($0) }
                                        ),
                                        in: Double(priceRange.lowerBound)...Double(viewModel.filters.maxPrice),
                                        step: Double(priceStep)
                                    )
                                    .tint(AppTheme.accent)
                                    .padding(.leading, 8)
                                }
                                
                                HStack {
                                    Text("Max")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Slider(
                                        value: Binding(
                                            get: { Double(viewModel.filters.maxPrice) },
                                            set: { viewModel.filters.maxPrice = Int($0) }
                                        ),
                                        in: Double(viewModel.filters.minPrice)...Double(priceRange.upperBound),
                                        step: Double(priceStep)
                                    )
                                    .tint(AppTheme.accent)
                                    .padding(.leading, 8)
                                }
                            }
                        }
                    }
                    
                    // Bedrooms
                    filterSection(title: "Bedrooms") {
                        HStack(spacing: 12) {
                            ForEach(0...4, id: \.self) { n in
                                filterCapsule(
                                    title: n == 0 ? "Any" : "\(n)+",
                                    isSelected: viewModel.filters.minBedrooms == n
                                ) {
                                    viewModel.filters.minBedrooms = n
                                }
                            }
                        }
                    }
                    
                    // Bathrooms
                    filterSection(title: "Bathrooms") {
                        HStack(spacing: 12) {
                            ForEach([0.0, 1.0, 2.0, 3.0, 4.0], id: \.self) { n in
                                filterCapsule(
                                    title: n == 0 ? "Any" : "\(Int(n))+",
                                    isSelected: viewModel.filters.minBathrooms == n
                                ) {
                                    viewModel.filters.minBathrooms = n
                                }
                            }
                        }
                    }
                    
                    // Listing Type
                    filterSection(title: "Show Only") {
                        VStack(spacing: 16) {
                            Toggle("New listings only", isOn: $viewModel.filters.newListingOnly)
                                .tint(AppTheme.accent)
                            Divider()
                            Toggle("Open house only", isOn: $viewModel.filters.openHouseOnly)
                                .tint(AppTheme.accent)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        viewModel.filters = PropertyFilters()
                    }
                    .foregroundStyle(.secondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.accent)
                }
            }
        }
    }
    
    private func filterSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
    
    private func filterCapsule(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundStyle(isSelected ? .white : .primary)
                .background(isSelected ? AppTheme.accent : Color(.systemGray6))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func formatPrice(_ value: Int) -> String {
        if value >= 1_000_000 {
            return String(format: "$%.1fM", Double(value) / 1_000_000)
        }
        return "$\(value / 1000)k"
    }
}
