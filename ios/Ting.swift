//
//  Ting.swift
//  Ting
//
//  Created by Bảo Hà on 25/06/2023.
//

import Foundation
import SPIndicator
import Foundation
import UIKit

extension UIImage {
    convenience init?(rct_imageFromBundleAssetName name: String) {
        let bundle = Bundle.main
        if let imagePath = bundle.path(forResource: name, ofType: nil) {
            self.init(contentsOfFile: imagePath)
        } else {
            self.init(named: name)
        }
    }
}

@objc
open class TingModule: NSObject {
    
    static func getImage(icon: Any?) -> UIImage? {
        if let image = UIImage(rct_imageFromBundleAssetName: "toast.png") {
            return image
        } else {
            return nil
        }
    }
    
    @objc(toast:)
    public static func toast(toastOption: NSDictionary) -> Void {
        DispatchQueue.main.async {
            var preset: SPIndicatorIconPreset?
            
            var options: ToastOptions = ToastOptions(options: toastOption)
            
            // custom icon
            if let iconFile = toastOption["icon"] {
                print("iconFile: ", iconFile)
                if let icon = getImage(icon: iconFile) {
                    print("icon: ", icon)
                    options.icon = .init(image: icon, color: .blue)
                    options.preset = .custom
                }
            }
            
            do {
                preset = try options.preset.onPreset(options)
            } catch {
                print("Ting Toast error: \(error)")
            }
            
            
            let toastView = (preset != nil) ? SPIndicatorView(title: options.title, message: options.message, preset: preset ?? .done):  SPIndicatorView(title: options.title, message: options.message)
            
            if let duration = options.duration {
                toastView.duration = duration
            }
            
            
            if let iconSize = toastOption["iconSize"] as? CGFloat {
                toastView.layout.iconSize = .init(width: iconSize, height: iconSize)
            }
            
            toastView.dismissByDrag = options.shouldDismissByDrag
            toastView.presentSide = options.position.onPosition();
            toastView.present(haptic: options.haptic.onHaptic())
        }
    }
}
