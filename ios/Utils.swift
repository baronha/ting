//
//  Utils.swift
//  Ting
//
//  Created by BẢO HÀ on 28/06/2023.
//

import UIKit
import Foundation

extension UIImage {
    func getTintColor(_ color: UIColor) -> UIImage? {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color, renderingMode: .alwaysOriginal)
        }else{
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            // 1
            let drawRect = CGRect(x: 0,y: 0,width: size.width,height: size.height)
            // 2
            color.setFill()
            UIRectFill(drawRect)
            // 3
            draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
            
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage!
        }
    }
}

extension UIColor {
    static func hexStringToColor(_ stringToConvert: String?) -> UIColor? {
        if stringToConvert == nil {
            return nil
        }
        
        let noHashString = stringToConvert!.replacingOccurrences(of: "#", with: "")
        
        // Đảm bảo độ dài chuỗi hợp lệ
        guard noHashString.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: noHashString).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
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
