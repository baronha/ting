//
//  Type.swift
//  Ting
//
//  Created by Bảo Hà on 25/06/2023.
//

import UIKit
import SPAlert

enum TingError: Error {
    case invalidSystemName
}

// option for alert and toast
class Options {
    var title: String = ""
    var message: String? = ""
    var duration: TimeInterval
    var titleColor: UIColor? = nil
    var messageColor: UIColor? = nil
    var backgroundColor: UIColor? = nil
    var icon: UIImage? = nil
    var iconSize: CGSize? = nil
    
    init(option:NSDictionary){
        self.title = option["title"] as? String ?? "Title"
        self.message = option["message"] as? String
        self.duration = option["duration"] as? TimeInterval ?? 3
        self.backgroundColor = UIColor.parseColor(option["backgroundColor"] as? String)
        
        if let messageColor = option["messageColor"] as? String {
            self.messageColor = UIColor.parseColor(messageColor)
        }
        
        if let titleColor = option["titleColor"] as? String {
            self.titleColor = UIColor.parseColor(titleColor)
        }
        
        // custom icon
        if let icon = option["icon"] as? NSDictionary {
            if let iconSize = icon["size"] as? CGFloat {
                self.iconSize = .init(width: iconSize, height: iconSize)
            }
            
            if let customIcon = getCustomIcon(icon: icon) {
                self.icon = customIcon
            }
        }
    }
}

func getCustomIcon(icon: NSDictionary) -> UIImage? {
    if let iconURI = icon["uri"] as? String {
        if let iconImage = getImage(icon: iconURI) {
            let color = UIColor.parseColor(icon["tintColor"] as? String)
            if(color != nil){
                return iconImage.getTintColor(color!)
            }
            return iconImage
        }
        
    }
    return nil
}


class ToastOptions: Options {
    
    var shouldDismissByDrag: Bool
    
    var haptic: ToastHaptic
    
    var position: ToastPosition
    
    var preset: ToastPreset = ToastPreset.done
    
    init(options: NSDictionary) {
        self.shouldDismissByDrag = options["shouldDismissByDrag"] as? Bool ?? true
        self.position = ToastPosition(rawValue: options["position"] as? String ?? "top")!
        self.haptic = ToastHaptic(rawValue: options["haptic"] as? String ?? "none")!
        
        super.init(option: options)
        
        if(self.icon != nil){
            self.preset = .custom
        }else{
            if let preset = options["preset"] as? String {
                self.preset = ToastPreset(rawValue: preset)!
            }else{
                self.preset = ToastPreset.done
            }
        }
    }
    
}


class AlertOptions: Options {
    var preset: AlertPreset = AlertPreset.done
    
    var shouldDismissByTap: Bool = true
    
    var haptic: AlertHaptic = .none
    
    var borderRadius: CGFloat = 24
    
    
    init(options: NSDictionary) {
        self.preset = AlertPreset(rawValue: options["preset"] as? String ?? "done")!
        self.shouldDismissByTap = options["shouldDismissByTap"] as? Bool ?? true
        self.borderRadius = options["borderRadius"] as? CGFloat ?? 24
        self.haptic = AlertHaptic(rawValue: options["haptic"] as? String ?? "none")!
        
        super.init(option: options)
        
        if(self.icon != nil){
            self.preset = .custom
        }else{
            if let preset = options["preset"] as? String {
                self.preset = AlertPreset(rawValue: preset)!
            }else{
                self.preset = AlertPreset.done
            }
        }
        
    }
}


enum ToastPreset: String {
    case done
    case error
    case none
    case custom
    case spinner
    
    func onPreset(_ options: ToastOptions?) throws -> SPIndicatorIconPreset? {
        switch self {
        case .error:
            return .error
        case .none:
            return .none
        case .spinner:
            if #available(iOS 13.0, *) {
                return .spin(.medium)
            } else {
                return .spin(.gray)
            }
        case .custom:
            guard let image = options?.icon ?? UIImage.init(named: "swift") else {
                throw TingError.invalidSystemName
            }
            return .custom(image)
        default:
            // default is done
            return .done
        }
    }
}

struct ToastMargins {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?
}


struct Icon {
    var image: UIImage? = nil
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
    case spinner
    case custom
    
    func onPreset(_ options: AlertOptions?) throws -> SPAlertIconPreset {
        switch self {
        case .error:
            return .error
        case .spinner:
            return .spinner
        case .custom:
            guard let image = options?.icon ?? UIImage.init(named: "swift") else {
                throw TingError.invalidSystemName
            }
            return .custom(image)
        // default is done
        default:
            return .done
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
