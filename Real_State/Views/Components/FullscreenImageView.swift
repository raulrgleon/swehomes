//
//  FullscreenImageView.swift
//  Real_State
//
//  Visor fullscreen de imágenes con zoom y swipe.
//

import SwiftUI

struct FullscreenImageView: View {
    let imageNames: [String]
    let initialIndex: Int
    @Binding var isPresented: Bool
    @State private var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    init(imageNames: [String], initialIndex: Int, isPresented: Binding<Bool>) {
        self.imageNames = imageNames
        self.initialIndex = initialIndex
        self._isPresented = isPresented
        self._currentIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture(count: 2) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale > 1 {
                            scale = 1
                            lastScale = 1
                        } else {
                            scale = 2.5
                            lastScale = 2.5
                        }
                    }
                }

            TabView(selection: $currentIndex) {
                ForEach(Array(imageNames.enumerated()), id: \.offset) { index, name in
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(currentIndex == index ? scale : 1)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = lastScale * value
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1 {
                                        scale = 1
                                        lastScale = 1
                                    } else if scale > 4 {
                                        scale = 4
                                        lastScale = 4
                                    }
                                }
                        )
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onChange(of: currentIndex) { _, _ in
                scale = 1
                lastScale = 1
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }
                    .padding()
                }
                Spacer()
                Text("\(currentIndex + 1) / \(imageNames.count)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.bottom, 24)
            }
        }
        .statusBarHidden(true)
    }
}
