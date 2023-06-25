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

@objc
open class TingModule: NSObject {
    
    @objc(toast:)
    public static func toast(toastOption: NSDictionary) -> Void {
        DispatchQueue.main.async {
            var preset: SPIndicatorIconPreset?
            
            let options: ToastOptions = ToastOptions(options: toastOption)
                        
            do {
                preset = try options.preset.onPreset(options)
            } catch {
                print("Ting Toast error: \(error)")
            }
            let toastView = (preset != nil) ? SPIndicatorView(title: options.title, message: options.message, preset: preset ?? .done):  SPIndicatorView(title: options.title, message: options.message)
            
            if let duration = options.duration {
                toastView.duration = duration
            }
            
            if let icon = options.layout?.iconSize {
                toastView.layout.iconSize = .init(width: icon.width, height: icon.height)
            }
            
            toastView.dismissByDrag = options.shouldDismissByDrag
            toastView.presentSide = options.position.onPosition();
            toastView.present(haptic: options.haptic.onHaptic())
        }
    }
}
