//
//  Type.swift
//  Ting
//
//  Created by Bảo Hà on 25/06/2023.
//

import UIKit
import SPIndicator

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
        self.preset = options["preset"] as? ToastPreset ?? .done
        self.shouldDismissByDrag = options["shouldDismissByDrag"] as? Bool ?? true
        self.haptic = options["haptic"] as? ToastHaptic ?? .none
        self.position = options.value(forKeyPath: "position") as? ToastPosition ?? .top
        self.duration = options["duration"] as? TimeInterval ?? 1
        
        print(options.value(forKeyPath: "position"), self.position)
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
            guard let image = UIImage.init( systemName: options?.icon?.name ?? "swift") else {
                throw TingError.invalidSystemName
            }
            return .custom(image.withTintColor(options?.icon?.color ?? .systemBlue, renderingMode: .alwaysOriginal))
        }
    }
}

struct ToastMargins {
    var top: CGFloat?
    var left: CGFloat?
    var bottom: CGFloat?
    var right: CGFloat?
}


struct IconSize {
    
    var width: Int
    var height: Int
}
struct ToastLayout {
    var iconSize: IconSize?
    var margins: ToastMargins?
}

struct Icon {
    
    var name: String? = nil
    
    var color: UIColor = .systemGray
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
