//
//  File.swift
//  
//
//  Created by Maciej Świć on 2022-03-19.
//

import SwiftUI

@available(iOS 15.0, macOS 12.00, *)
struct SwiftHUDOverlayModifier: ViewModifier {
    @Binding var isActive: Bool
    @Binding var overlay: SwiftHUD
    
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
                        GroupBox {
                            VStack(spacing: 10) {
                                switch overlay.accessory {
                                case .progress:
                                    ProgressView()
                                case .systemImage(let name):
                                    Image(systemName: name)
                                case .image(let image):
                                    image
                                }
                                if let message = overlay.message {
                                    Text(message.trimmingCharacters(in: .whitespacesAndNewlines))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(10)
                        }
                        .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 0)
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
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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
