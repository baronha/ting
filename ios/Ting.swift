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
import SPAlert

@objc
open class TingModule: NSObject {
    
    static func getImage(icon: String) -> UIImage? {
        if let url = URL.init(string: icon) {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    return image
                }
            }
        }
        return nil
    }
    
    @objc(toast:)
    public static func toast(toastOption: NSDictionary) -> Void {
        DispatchQueue.main.async {
            var preset: SPIndicatorIconPreset?
            
            var options: ToastOptions = ToastOptions(options: toastOption)
            
            // custom icon
            if let icon = toastOption["icon"] as? NSDictionary {
                let tintColor = Utils.hexStringToColor(icon["tintColor"] as? String)
                
                if let iconSize = icon["size"] as? CGFloat {
                    options.layout = .init(iconSize: iconSize, margins: nil)
                }
                
                if let iconURI = icon["uri"] as? String {
                    if let icon = getImage(icon: iconURI) {
                        options.icon = .init(image: icon, color: tintColor)
                        options.preset = .custom
                    }
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
            
            
            if let iconSize = options.layout?.iconSize as? CGFloat {
                toastView.layout.iconSize = .init(width: iconSize, height: iconSize)
            }
            
            toastView.dismissByDrag = options.shouldDismissByDrag
            toastView.presentSide = options.position.onPosition();
            toastView.present(haptic: options.haptic.onHaptic())
        }
    }
    
    @objc(alert:)
    public static func alert(alertOption: NSDictionary) -> Void {
        var preset: SPAlertIconPreset?
        
        var options: AlertOptions = AlertOptions(options: alertOption)
        
        // custom icon
        if let icon = alertOption["icon"] as? NSDictionary {
            let tintColor = Utils.hexStringToColor(icon["tintColor"] as? String)
            
            if let iconSize = icon["size"] as? CGFloat {
                options.layout = .init(iconSize: iconSize)
            }
            
            if let iconURI = icon["uri"] as? String {
                if let icon = getImage(icon: iconURI) {
                    options.icon = .init(image: icon, color: tintColor)
                    options.preset = .custom
                }
            }
        }
        
        do {
            preset = try options.preset.onPreset(options)
        } catch {
            print("Ting Toast error: \(error)")
        }
        
        let alertView = SPAlertView(
            title: options.title,
            message: options.message,
            preset: preset ?? .done)
        
        
        if let duration = options.duration {
            alertView.duration = duration
        }
        
        
        if let duration = options.duration {
            alertView.duration = duration
        }
        
        alertView.dismissByTap = options.shouldDismissByTap
        
        alertView.cornerRadius = options.borderRadius
        
        
        
        if let iconSize = options.layout?.iconSize as? CGFloat {
            alertView.layout.iconSize = .init(width: iconSize, height: iconSize)
        }
        
        DispatchQueue.main.async {
            alertView.present(
                haptic: options.haptic.toSPAlertHaptic())
        }
    }
}
