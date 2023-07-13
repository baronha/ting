//
//  Ting.swift
//  Ting
//
//  Created by Bảo Hà on 25/06/2023.
//

import Foundation
import UIKit
import SPAlert

@objc
open class TingModule: NSObject {
    
    static var toastView: SPIndicatorView? = nil;
    static var alertView: SPAlertView? = nil;
    
    static var toastOptionInit: NSDictionary = [:]
    static var alertOptionInit: NSDictionary = [:]
    
    @objc(toast:)
    public static func toast(toastOption: NSDictionary) -> Void {
        var preset: SPIndicatorIconPreset?
        
        let optionInit = mergeOptionInit(dictionary: toastOptionInit, optionDict: toastOption)
        let options: ToastOptions = ToastOptions(options: optionInit)
        
        do {
            preset = try options.preset.onPreset(options)
        } catch {
            print("Ting Toast error: \(error)")
        }
        
        DispatchQueue.main.async {
            toastView?.dismiss() // Dismiss old toast before show new toast
            
            toastView = (preset != nil) ? SPIndicatorView(title: options.title, message: options.message, preset: preset ?? .done):  SPIndicatorView(title: options.title, message: options.message)
            
            if(toastView != nil){
                
                if let titleColor = options.titleColor {
                    toastView!.titleLabel?.textColor = titleColor
                }
                
                if let messageColor = options.messageColor {
                    toastView!.subtitleLabel?.textColor = messageColor
                }
                
                toastView!.duration = options.duration
                
                if let iconSize = options.iconSize {
                    toastView!.layout.iconSize = iconSize
                }
                
                toastView!.dismissByDrag = options.shouldDismissByDrag
                toastView!.presentSide = options.position.onPosition();
                
                toastView!.present(haptic: options.haptic.onHaptic())
                setBackgroundColor(parentView: toastView, backgroundColor: options.backgroundColor ?? nil)
            }
        }
    }
    
    
    @objc(alert:)
    public static func alert(alertOption: NSDictionary) -> Void {
        var preset: SPAlertIconPreset?
        
        let optionInit = mergeOptionInit(dictionary: alertOptionInit, optionDict: alertOption)
        let options: AlertOptions = AlertOptions(options: optionInit)
        
        do {
            preset = try options.preset.onPreset(options)
        } catch {
            print("Ting Alert error: \(error)")
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
                
                if let titleColor = options.titleColor {
                    alertView!.titleLabel?.textColor = titleColor
                }
                
                if let messageColor = options.messageColor {
                    alertView!.subtitleLabel?.textColor = messageColor
                }
                
                alertView!.duration = options.duration
                
                if let iconSize = options.iconSize {
                    alertView!.layout.iconSize = iconSize
                }
                                
                if let iconSize = options.iconSize {
                    alertView!.layout.iconSize = iconSize
                }
                
                alertView!.present(
                    haptic: options.haptic.toSPAlertHaptic()
                )
                
                setBackgroundColor(parentView: alertView, backgroundColor: options.backgroundColor ?? nil)
            }
        }
    }
    
    static func mergeOptionInit(dictionary: NSDictionary, optionDict: NSDictionary) -> NSDictionary {
        let mergedDict = NSMutableDictionary(dictionary: dictionary)
        mergedDict.addEntries(from: optionDict as! [AnyHashable: Any])
        let option = NSDictionary(dictionary: mergedDict)
        
        return option
    }
    
    
    @objc(setup:)
    public static func setup(initOptions: NSDictionary) -> Void {
        if let toastOption = initOptions["toast"] as? NSDictionary {
            toastOptionInit = NSDictionary(dictionary: toastOption)

        }
        
        if let alertOption = initOptions["alert"] as? NSDictionary {
            alertOptionInit = NSDictionary(dictionary: alertOption)
        }
    }
    
    @objc(dismissAlert)
    public static func dismissAlert() -> Void {
        DispatchQueue.main.async {
            SPAlert.dismiss()
        }
    }
}

func getIcon(options: NSDictionary) -> NSDictionary? {
    if let icon = options["icon"] as? NSDictionary {
        return icon
    }
    return nil
}

func setBackdrop(alertView:  SPAlertView,  options: NSDictionary) -> Void {
    let windowView = alertView.presentWindow
    
    let view = UIView(frame: windowView!.bounds)
    view.backgroundColor = .gray
    windowView!.insertSubview(view, at: 1)
    
}


func setBackgroundColor(parentView: UIView?, backgroundColor: UIColor?) -> Void {
    if(parentView != nil && backgroundColor != nil){
        parentView!.layer.masksToBounds = true
        let view = UIView(frame: parentView!.bounds)
        view.backgroundColor = backgroundColor
        parentView!.insertSubview(view, at: 1)
        
    }
}
