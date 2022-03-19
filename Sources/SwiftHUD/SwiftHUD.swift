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
@available(iOS 15.0, macOS 10.15, *)
public struct SwiftHUD {
    /**
     Each `SwiftHUD` has an accessory. The accessory is displayed as the topmost item of the HUD view.
     */
    public enum Accessory: Equatable {
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
    /** If `true, the HUD can be tapped to dismiss it. */
    var tapToDismiss: Bool
    /** Optional timer. If set, will dismiss the overlay after the time expires. */
    var dismissAfter: TimeInterval?
    /** Optional closure. If set, will execute itself immediately and dismiss the overlay on completion. */
    var closure: (() -> Void)?
    
    /** Internal weak reference to an optional manager, in case the HUD needs to dismiss itself in a managed context. */
    internal weak var manager: SwiftHUDOverlayManager?
    
    /**
     Creates a new SwiftHUD.
     
     - Parameter accessory: Mandatory accessory that is displayed in the topmost position of the HUD.
     - Parameter message: Optional message that is displayed below the accessory.
     - Parameter disablesBackground: If set to `true` will `.disable` the views behind the HUD, and apply a slight dimming effect.
     - Parameter tapToDismiss: If set to `true`, the HUD can be dismissed by tapping it, or the backgorund.
     - Parameter dismissAfter: Optional TimeInterval that controls automatic dismissal.
     - Parameter closure: Optional closure that is executed immediately. Dismisses the HUD automatically on completion.
     */
    public init(accessory: Accessory, message: String? = nil, disablesBackground: Bool = true, tapToDismiss: Bool = false, dismissAfter: TimeInterval? = nil, closure: (() -> Void)? = nil) {
        self.accessory = accessory
        self._message = .constant(message)
        self.disablesBackground = disablesBackground
        self.tapToDismiss = tapToDismiss
        self.dismissAfter = dismissAfter
        self.closure = closure
    }
    
    /**
     Creates a new SwiftHUD.
     
     - Parameter accessory: Mandatory accessory that is displayed in the topmost position of the HUD.
     - Parameter message: Optional message that is displayed below the accessory.
     - Parameter disablesBackground: If set to `true` will `.disable` the views behind the HUD, and apply a slight dimming effect.
     - Parameter tapToDismiss: If set to `true`, the HUD can be dismissed by tapping it, or the backgorund.
     - Parameter dismissAfter: Optional TimeInterval that controls automatic dismissal.
     - Parameter closure: Optional closure that is executed immediately. Dismisses the HUD automatically on completion.
     */
    public init(accessory: Accessory, message: (Binding<String?>)? = nil, disablesBackground: Bool = true, tapToDismiss: Bool = false, dismissAfter: TimeInterval? = nil, closure: (() -> Void)? = nil) {
        self.accessory = accessory
        self._message = message ?? .constant(nil)
        self.disablesBackground = disablesBackground
        self.tapToDismiss = tapToDismiss
        self.dismissAfter = dismissAfter
        self.closure = closure
    }
}

extension SwiftHUD: Equatable {
    public static func == (lhs: SwiftHUD, rhs: SwiftHUD) -> Bool {
        lhs.accessory == rhs.accessory && lhs.message == rhs.message
    }
}
