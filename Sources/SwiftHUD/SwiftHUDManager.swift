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
@available(iOS 15.0, macOS 12.00, *)
public class SwiftHUDOverlayManager: ObservableObject {
    /** The shared manager can be used in situations where you need to display a `SwiftHUD` from a very remote location. Where possible, you should use a local manager. */
    public static var shared = SwiftHUDOverlayManager()
    
    /** The currently displayed `SwiftHUD`, if no HUD is being displayed, this value is nil. */
    @Published public var overlay: SwiftHUD?
    
    public init() {}
    
    /** Presents the specified `SwiftHUD` immediately. If this manager is already presenting a HUD, it will be replaced. */
    public func present(overlay: SwiftHUD) {
        var overlay = overlay
        
        overlay.manager = self
        
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(dismissAfter * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                if self.overlay == overlay {
                    self.dismiss()
                }
            }
        }
        
        // If there is haptic feedback, trigger it.
        if let hapticFeedback = overlay.hapticFeedback {
            hapticFeedback.trigger()
        }
    }
    
    /** Immediately dismisses the HUD */
    public func dismiss() {
        self.overlay = nil
    }
}

struct SwiftHUDManagedOverlayModifier: ViewModifier {
    @ObservedObject var manager: SwiftHUDOverlayManager
    
    @State var isActive = true
    
    func body(content: Content) -> some View {
        Group {
            if let overlay = manager.overlay {
                content
                .swiftHUD(isActive: $isActive, overlay: overlay)
            } else {
                content
            }
        }
        .onChange(of: manager.overlay) { newOverlay in
            isActive = newOverlay != nil
        }
    }
}
