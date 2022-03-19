//
//  SwiftHUDManager.swift
//  Exam App
//
//  Created by Maciej Świć on 2022-03-19.
//

import SwiftUI

/**
 A SwiftHUDOverlayManager is optional and can be used in more complex uses-cases where you need to present more HUDs in sequence, or trigger display from difficult locations in your code.
 
 To present a singular HUD once from SwiftUI, you should probably just use the `.swiftHUD(...)` view modifier. The Manager is not necessary in this case.
 */
class SwiftHUDOverlayManager: ObservableObject {
    /** The shared manager can be used in situations where you need to display a `SwiftHUD` from a very remote location. Where possible, you should use a local manager. */
    static var shared = SwiftHUDOverlayManager()
    
    /** The currently displayed `SwiftHUD`, if no HUD is being displayed, this value is nil. */
    @Published var overlay: SwiftHUD?
    
    /** Presents the specified `SwiftHUD` immediately. If this manager is already presenting a HUD, it will be replaced. */
    func present(overlay: SwiftHUD) {
        withAnimation {
            self.overlay = overlay
        }
        
        // If there is a closure, dismiss when the closure finishes
        if let closure = overlay.closure {
            closure()
            
            if self.overlay == overlay {
                dismiss()
            }
        }
        
        // If the overlay is set to auto-dismiss, do that after the configured time
        if let dismissAfter = overlay.dismissAfter {
            delay(dismissAfter) {
                if self.overlay == overlay {
                    self.dismiss()
                }
            }
        }
    }
    
    /** Immediately dismisses the HUD */
    func dismiss() {
        self.overlay = nil
    }
}

struct SwiftHUDManagedOverlayModifier: ViewModifier {
    @ObservedObject var manager: SwiftHUDOverlayManager
    
    func body(content: Content) -> some View {
        if let overlay = manager.overlay {
            content
            .swiftHUD(isActive: .constant(true), overlay: overlay)
        } else {
            content
        }
    }
}

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
                                Text(message)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding(10)
                    }
                    .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 0)
                }
                // Cover content view entirely
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            content
        }
    }
}
