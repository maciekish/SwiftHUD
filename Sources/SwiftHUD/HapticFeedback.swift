//
//  File.swift
//  
//
//  Created by Maciej Swic on 2023-02-02.
//

import SwiftUI

public enum HapticFeedback: Equatable {
    /** `impact` is used to give user feedback when an impact between UI elements occurs. */
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat),
    /** `selection` is used to give user feedback when a selection changes. */
    selection,
    /** `notification` is used to give user feedback when an notification is displayed. */
    notification(type: UINotificationFeedbackGenerator.FeedbackType)
    
    func trigger() {
        switch self {
        case .impact(let style, let intensity):
            UIImpactFeedbackGenerator(style: style).impactOccurred(intensity: intensity)
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .notification(let type):
            UINotificationFeedbackGenerator().notificationOccurred(type)
        }
    }
}
