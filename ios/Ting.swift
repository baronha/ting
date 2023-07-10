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
    
    static var toastView: SPIndicatorView? = nil;
    static var alertView: SPAlertView? = nil;
    
    @objc(toast:)
    public static func toast(toastOption: NSDictionary) -> Void {
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
        
        DispatchQueue.main.async {
            toastView?.dismiss() // Dismiss old alert before show new toast
            
            toastView = (preset != nil) ? SPIndicatorView(title: options.title, message: options.message, preset: preset ?? .done):  SPIndicatorView(title: options.title, message: options.message)
            
            if(toastView != nil){
                if let titleColor = Utils.hexStringToColor(toastOption["titleColor"] as? String) {
                    toastView!.titleLabel?.textColor = titleColor
                }
                
                if let messageColor = Utils.hexStringToColor(toastOption["messageColor"] as? String) {
                    toastView!.subtitleLabel?.textColor = messageColor
                }
                
                if let duration = options.duration {
                    toastView!.duration = duration
                }
                
                if let iconSize = options.layout?.iconSize as? CGFloat {
                    toastView!.layout.iconSize = .init(width: iconSize, height: iconSize)
                }
                
                toastView!.dismissByDrag = options.shouldDismissByDrag
                toastView!.presentSide = options.position.onPosition();
                
                toastView!.present(haptic: options.haptic.onHaptic())
                setBackgroundColor(parentView: toastView, options: toastOption)
            }
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
            print("Ting error: \(error)")
        }
        
        DispatchQueue.main.async {
            alertView?.dismiss() // Dismiss old alert before show new alert
            alertView = SPAlertView(
                title: options.title,
                message: options.message,
                preset: preset ?? .done)
            
            
            if(alertView != nil) {
                
                alertView!.dismissByTap = options.shouldDismissByTap
                alertView!.cornerRadius = options.borderRadius
                
                if let titleColor = Utils.hexStringToColor(alertOption["titleColor"] as? String) {
                    alertView!.titleLabel?.textColor = titleColor
                }
                
                if let messageColor = Utils.hexStringToColor(alertOption["messageColor"] as? String) {
                    alertView!.subtitleLabel?.textColor = messageColor
                }
                
                if let duration = options.duration {
                    alertView!.duration = duration
                }
                
                if let iconSize = options.layout?.iconSize as? CGFloat {
                    alertView!.layout.iconSize = .init(width: iconSize, height: iconSize)
                }
                
                alertView!.present(
                    haptic: options.haptic.toSPAlertHaptic())
                
                setBackgroundColor(parentView: alertView, options: alertOption)
            }
        }
    }
    
    @objc(dismissAlert)
    public static func dismissAlert() -> Void {
        DispatchQueue.main.async {
            SPAlert.dismiss()
        }
    }
}

func setBackgroundColor(parentView: UIView?, options: NSDictionary) -> Void {
    if(parentView != nil){
        if let backgroundColor = Utils.hexStringToColor(options["backgroundColor"] as? String) {
            parentView!.layer.masksToBounds = true
            
            let view = UIView(frame: parentView!.bounds)
            view.frame = parentView!.bounds
            view.backgroundColor = backgroundColor
            parentView!.insertSubview(view, at: 1)
            
        }
    }
}

func getImage(icon: String) -> UIImage? {
    if let url = URL.init(string: icon) {
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                return image
            }
        }
    }
    return nil
}
