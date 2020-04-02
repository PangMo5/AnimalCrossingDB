//
//  SwiftEntryKit+GangnamSister.swift
//
//  Created by Shirou on 2020/01/11.
//  Copyright © 2020 Shirou. All rights reserved.
//

import UIKit
import SwiftEntryKit

enum ToastType {
    case alert
    case error
    
    var name: String {
        switch self {
        case .alert:
            return "AlertToast"
        case .error:
            return "ErrorToast"
        }
    }
    
    var hapticFeedbackType: EKAttributes.NotificationHapticFeedback {
        switch self {
        case .alert:
            return .none
        case .error:
            return .error
        }
    }
    
    var displayDuration: EKAttributes.DisplayDuration {
        switch self {
        case .alert:
            return 5
        case .error:
            return .infinity
        }
    }
    
    var entryBackground: EKAttributes.BackgroundStyle {
        switch self {
        case .alert, .error:
            return .visualEffect(style: .standard)
        }
    }
}

extension SwiftEntryKit {

    class func showToast(title: String = "", message: String, toastType: ToastType = .alert) {

        var attributes = EKAttributes()
        attributes.name = toastType.name
        attributes.displayDuration = toastType.displayDuration
        attributes.entryBackground = toastType.entryBackground
        attributes.position = .bottom
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.hapticFeedbackType = toastType.hapticFeedbackType
        
        let simpleMessage = EKSimpleMessage(title: .init(text: title, style: .init(font: .systemFont(ofSize: 16), color: .standardContent)),
                                            description: .init(text: message, style: .init(font: .systemFont(ofSize: 14), color: .standardContent, alignment: .center)))
        
        var insets = EKNotificationMessage.Insets.default
        insets.contentInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage, insets: insets)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
