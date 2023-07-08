//
//  Type.swift
//  Ting
//
//  Created by Bảo Hà on 25/06/2023.
//

import UIKit
import SPIndicator
import SPAlert

enum TingError: Error {
    case invalidSystemName
}

struct ToastOptions {
    var title: String
    
    var message: String?
    
    var preset: ToastPreset
    
    var duration: TimeInterval? = 1
    
    var layout: ToastLayout?
    
    var shouldDismissByDrag: Bool
    
    var haptic: ToastHaptic
    
    var position: ToastPosition
    
    var icon: Icon? = nil
    
    init(options: NSDictionary) {
        self.title = options["title"] as? String ?? "Title"
        self.message = options["message"] as? String
        self.duration = options["duration"] as? TimeInterval
        self.shouldDismissByDrag = options["shouldDismissByDrag"] as? Bool ?? true
        
        self.position = ToastPosition(rawValue: options["position"] as? String ?? "top")!
        self.preset = ToastPreset(rawValue: options["preset"] as? String ?? "done")!
        self.haptic = ToastHaptic(rawValue: options["haptic"] as? String ?? "none")!
    }
    
}

enum ToastPreset: String {
    case done
    case error
    case none
    case custom
    
    func onPreset(_ options: ToastOptions?) throws -> SPIndicatorIconPreset? {
        switch self {
        case .done:
            return .done
        case .error:
            return .error
        case .none:
            return .none
        case .custom:
            guard let image = options?.icon?.image ?? UIImage.init(named: "swift") else {
                throw TingError.invalidSystemName
            }
            
            if let iconColor = options?.icon?.color {
                return .custom(image.withTintColor(iconColor, renderingMode: .alwaysOriginal))
            }else{
                return .custom(image)
            }
        }
    }
}

struct ToastMargins {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?
}


struct ToastLayout {
    var iconSize: CGFloat?
    var margins: ToastMargins?
}

struct Icon {
    var image: UIImage? = nil
    var color: UIColor? = nil
}


enum ToastHaptic: String {
    case success
    case warning
    case error
    case none
    
    func onHaptic() -> SPIndicatorHaptic {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .none:
            return .none
        }
    }
}

enum ToastPosition: String, CaseIterable {
    case top
    case bottom
    
    func onPosition() -> SPIndicatorPresentSide {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

enum AlertPreset: String, CaseIterable {
    case done
    case error
    case heart
    case spinner
    case custom
    
    func onPreset(_ options: AlertOptions?) throws -> SPAlertIconPreset {
        switch self {
        case .done:
            return .done
        case .error:
            return .error
        case .heart:
            return .heart
        case .spinner:
            return .spinner
        case .custom:
            guard let image = options?.icon?.image ?? UIImage.init(named: "swift") else {
                throw TingError.invalidSystemName
            }
            
            if let iconColor = options?.icon?.color {
                return .custom(image.withTintColor(iconColor, renderingMode: .alwaysOriginal))
            }else{
                return .custom(image)
            }
        }
    }
}


enum AlertHaptic: String, CaseIterable {
    case success
    case warning
    case error
    case none
    
    func toSPAlertHaptic() -> SPAlertHaptic {
        switch self {
        case .success:
            return .success
        case .warning:
            return .warning
        case .error:
            return .error
        case .none:
            return .none
        }
    }
}

struct AlertLayout {
    var iconSize: CGFloat?
}

struct AlertOptions {
    var title: String = ""
    
    var message: String?
    
    var preset: AlertPreset = AlertPreset.done
    
    var duration: TimeInterval?
    
    var shouldDismissByTap: Bool = true
    
    var haptic: AlertHaptic = .none
    
    var layout: AlertLayout?
    
    var icon: Icon? = nil
    
    var borderRadius: CGFloat = 24
    
    
    init(options: NSDictionary) {
        self.title = options["title"] as? String ?? "Title"
        self.message = options["message"] as? String
        self.duration = options["duration"] as? TimeInterval
        self.shouldDismissByTap = options["shouldDismissByTap"] as? Bool ?? true
        self.borderRadius = options["borderRadius"] as? CGFloat ?? 24
        self.preset = AlertPreset(rawValue: options["preset"] as? String ?? "done")!
        self.haptic = AlertHaptic(rawValue: options["haptic"] as? String ?? "none")!
    }
}
