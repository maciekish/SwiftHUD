//
//  SwiftHUD.swift
//  Exam App
//
//  Created by Maciej Świć on 2022-03-19.
//

import SwiftUI

/**
 An instance of a `SwiftHUD`. A `SwiftHUD` is a simple struct that contains data to construct an overlay view in the `SwiftHUDOverlayModifier` when required.
 */
struct SwiftHUD {
    /**
     Each `SwiftHUD` has an accessory. The accessory is displayed as the topmost item of the HUD view.
     */
    enum Accessory: Equatable {
             /** `progress` displays an animated `ProgressView` as the accessory. */
        case progress,
             /** `systemImage` displays an SF Symbol` as the accessory. */
             systemImage(name: String),
             /** `image` displays an arbitrary image as the accessory. */
             image(image: Image)
    }
    
    /** Defines the accessory of this `SwiftHUD` */
    var accessory: Accessory
    /** An optional message, displayed below the accessory. Being a binding, it can be updated remotely, or you can replace the whole `SwiftHUD` by simply displaying a new one */
    @Binding var message: String?
    /** Controls whether the overlay disableds the content behind it. If true, the content will be `.disabled` and slightly dimmed. */
    var disablesBackground: Bool
    /** Optional timer. If set, will dismiss the overlay after the time expires. */
    var dismissAfter: TimeInterval?
    /** Optional closure. If set, will execute itself immediately and dismiss the overlay on completion. */
    var closure: (() -> Void)?
    
    /**
     Creates a new SwiftHUD.
     
     - Parameter accessory: Mandatory accessory that is displayed in the topmost position of the HUD.
     - Parameter message: Optional message that is displayed below the accessory.
     - Parameter disablesBackground: If set to `true` will `.disable` the views behind the HUD, and apply a slight dimming effect.
     - Parameter dismissAfter: Optional TimeInterval that controls automatic dismissal.
     - Parameter closure: Optional closure that is executed immediately. Dismisses the HUD automatically on completion.
     */
    init(accessory: Accessory, message: String? = nil, disablesBackground: Bool = true, dismissAfter: TimeInterval? = nil, closure: (() -> Void)? = nil) {
        self.accessory = accessory
        self._message = .constant(message)
        self.disablesBackground = disablesBackground
        self.dismissAfter = dismissAfter
        self.closure = closure
    }
    
    /**
     Creates a new SwiftHUD.
     
     - Parameter accessory: Mandatory accessory that is displayed in the topmost position of the HUD.
     - Parameter message: Optional message that is displayed below the accessory.
     - Parameter disablesBackground: If set to `true` will `.disable` the views behind the HUD, and apply a slight dimming effect.
     - Parameter dismissAfter: Optional TimeInterval that controls automatic dismissal.
     - Parameter closure: Optional closure that is executed immediately. Dismisses the HUD automatically on completion.
     */
    init(accessory: Accessory, message: (Binding<String?>)? = nil, disablesBackground: Bool = true, dismissAfter: TimeInterval? = nil, closure: (() -> Void)? = nil) {
        self.accessory = accessory
        self._message = message ?? .constant(nil)
        self.disablesBackground = disablesBackground
        self.dismissAfter = dismissAfter
        self.closure = closure
    }
}

extension SwiftHUD: Equatable {
    static func == (lhs: SwiftHUD, rhs: SwiftHUD) -> Bool {
        lhs.accessory == rhs.accessory && lhs.message == rhs.message
    }
}
