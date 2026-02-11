//
//  PropertyImageView.swift
//  Real_State
//
//  Muestra imagen de propiedad: asset local o URL remota.
//

import SwiftUI

struct PropertyImageView: View {
    let property: Property
    var height: CGFloat = 160
    var width: CGFloat? = nil

    var body: some View {
        Group {
            if let urls = property.imageURLs, !urls.isEmpty, let url = URL(string: urls[0]) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        HeroPlaceholderView(styleIndex: property.imageStyleIndex)
                    case .empty:
                        HeroPlaceholderView(styleIndex: property.imageStyleIndex)
                    @unknown default:
                        HeroPlaceholderView(styleIndex: property.imageStyleIndex)
                    }
                }
            } else if let name = property.imageName {
                Image(name)
                    .resizable()
                    .scaledToFill()
            } else {
                HeroPlaceholderView(styleIndex: property.imageStyleIndex)
            }
        }
        .frame(width: width, height: height)
        .clipped()
    }
}
