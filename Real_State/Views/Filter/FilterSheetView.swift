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
            Form {
                Section("Price Range") {
                    HStack {
                        Text("Min")
                        Spacer()
                        Text(formatPrice(viewModel.filters.minPrice))
                            .foregroundStyle(.secondary)
                    }
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.filters.minPrice) },
                            set: { viewModel.filters.minPrice = Int($0) }
                        ),
                        in: Double(priceRange.lowerBound)...Double(viewModel.filters.maxPrice),
                        step: Double(priceStep)
                    )
                    HStack {
                        Text("Max")
                        Spacer()
                        Text(formatPrice(viewModel.filters.maxPrice))
                            .foregroundStyle(.secondary)
                    }
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.filters.maxPrice) },
                            set: { viewModel.filters.maxPrice = Int($0) }
                        ),
                        in: Double(viewModel.filters.minPrice)...Double(priceRange.upperBound),
                        step: Double(priceStep)
                    )
                }

                Section("Bedrooms") {
                    Picker("Minimum", selection: $viewModel.filters.minBedrooms) {
                        ForEach(0...5, id: \.self) { n in
                            Text(n == 0 ? "Any" : "\(n)+")
                                .tag(n)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Bathrooms") {
                    Picker("Minimum", selection: $viewModel.filters.minBathrooms) {
                        Text("Any").tag(0.0)
                        Text("1+").tag(1.0)
                        Text("2+").tag(2.0)
                        Text("3+").tag(3.0)
                    }
                    .pickerStyle(.menu)
                }

                Section("Listing") {
                    Toggle("New listing only", isOn: $viewModel.filters.newListingOnly)
                    Toggle("Open house only", isOn: $viewModel.filters.openHouseOnly)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") {
                        viewModel.filters = PropertyFilters()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func formatPrice(_ value: Int) -> String {
        if value >= 1_000_000 {
            return String(format: "$%.1fM", Double(value) / 1_000_000)
        }
        return "$\(value / 1000)k"
    }
}
