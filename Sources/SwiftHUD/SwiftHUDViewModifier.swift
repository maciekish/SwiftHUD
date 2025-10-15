//
//  File.swift
//  
//
//  Created by Maciej Świć on 2022-03-19.
//

import SwiftUI

@available(iOS 15.0, macOS 12.00, *)
struct SwiftHUDOverlayModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isActive: Bool
    @Binding var overlay: SwiftHUD
    
    private let cornerRadius: CGFloat = 32
    
    private var glassShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
    
    private var glassBorderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(colorScheme == .dark ? 0.45 : 0.6),
                Color.white.opacity(colorScheme == .dark ? 0.12 : 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var glassHighlightGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(colorScheme == .dark ? 0.32 : 0.45),
                Color.white.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    init(isActive: Binding<Bool>, overlay: Binding<SwiftHUD>) {
        self._isActive = isActive
        self._overlay = overlay
    }
    
    func body(content: Content) -> some View {
        if isActive {
            content
            // Disable all content in the background if requested.
                .disabled(overlay.disablesBackground)
                .overlay {
                    ZStack {
                        // Dim content in background if requested.
                        if overlay.disablesBackground {
                            Rectangle()
                                .foregroundColor(.black)
                                .opacity(0.33)
                        }
                        VStack(spacing: 16) {
                            switch overlay.accessory {
                            case .progress:
                                ProgressView()
                                    .tint(.primary)
                            case .systemImage(let name, let scale):
                                Image(systemName: name)
                                    .imageScale(scale)
                            case .image(let image):
                                image
                            }
                            if let message = overlay.message {
                                Text(message.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 24)
                        .background(glassShape.fill(.ultraThinMaterial))
                        .overlay(
                            glassShape
                                .fill(glassHighlightGradient)
                                .opacity(0.45)
                                .blur(radius: 18)
                                .mask(glassShape)
                                .allowsHitTesting(false)
                        )
                        .overlay(
                            glassShape
                                .strokeBorder(glassBorderGradient, lineWidth: 1)
                                .blendMode(.softLight)
                        )
                        .shadow(
                            color: Color.black.opacity(colorScheme == .dark ? 0.45 : 0.22),
                            radius: 28,
                            x: 0,
                            y: 16
                        )
                        .compositingGroup()
                    }
                    // Cover content view entirely
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        if overlay.tapToDismiss {
                            isActive = false
                            overlay.manager?.overlay = nil
                        }
                    }
                }
        } else {
            content
        }
    }
}

struct SwiftHUDOverlayModifier_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    Text("Lorem ipsum, dolor sit amet.")
                } header: {
                    Text("World")
                }
                .headerProminence(.increased)
            }
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button {
                        // Noop
                    } label: {
                        Text("Done")
                    }
                }
            }
            .navigationTitle("Hello, World!")
        }
        .swiftHUD(isActive: .constant(true), overlay: SwiftHUD(accessory: .progress, message: .constant("Loading...")))
    }
}
