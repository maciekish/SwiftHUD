//
//  View+Extensions.swift
//  Exam App
//
//  Created by Maciej Świć on 2022-03-19.
//

import SwiftUI

extension View {
    func swiftHUD(manager: SwiftHUDOverlayManager) -> some View {
        self
            .modifier(SwiftHUDManagedOverlayModifier(manager: manager))
    }
    
    func swiftHUD(isActive: Binding<Bool>, message: (Binding<String?>)? = nil) -> some View {
        self
            .modifier(SwiftHUDOverlayModifier(isActive: isActive, overlay: .constant(SwiftHUD(accessory: .progress, message: message))))
    }
    
    func swiftHUD(isActive: Binding<Bool>, message: String?) -> some View {
        self
            .modifier(SwiftHUDOverlayModifier(isActive: isActive, overlay: .constant(SwiftHUD(accessory: .progress, message: message))))
    }
    
    func swiftHUD(isActive: Binding<Bool>, overlay: SwiftHUD) -> some View {
        self
            .modifier(SwiftHUDOverlayModifier(isActive: isActive, overlay: .constant(overlay)))
    }
}
