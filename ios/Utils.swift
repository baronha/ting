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
    static func parseColor(_ colorString: String?) -> UIColor? {
        guard let colorString = colorString else {
            return nil
        }
        
        // Try parsing color as hex
        if colorString.hasPrefix("#") {
            let hexString = String(colorString.dropFirst()) // Remove '#' character
            
            // Check if the hex string has valid length
            guard hexString.count == 6 || hexString.count == 8 else {
                return .gray // Return gray color for invalid hex string
            }
            
            // Parse hex values
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            
            // Extract individual color components
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            let alpha = hexString.count == 8 ? CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0 : 1.0
            
            // Create and return UIColor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        // Try parsing color as named color
        if let namedColor = UIColor(named: colorString) {
            return namedColor
        }
        
        // Try parsing color as RGB or RGBA
        let rgbRegex = try! NSRegularExpression(pattern: #"rgba?\((\d{1,3}), (\d{1,3}), (\d{1,3})(, (\d(\.\d)?))?\)"#)
        if let rgbMatch = rgbRegex.firstMatch(in: colorString, range: NSRange(colorString.startIndex..., in: colorString)) {
            let red = Int(colorString[Range(rgbMatch.range(at: 1), in: colorString)!])!
            let green = Int(colorString[Range(rgbMatch.range(at: 2), in: colorString)!])!
            let blue = Int(colorString[Range(rgbMatch.range(at: 3), in: colorString)!])!
            let alpha = rgbMatch.numberOfRanges > 5 ? Float(colorString[Range(rgbMatch.range(at: 5), in: colorString)!])! : 1.0
            
            // If the color string starts with "rgb(", ignore the alpha component
            if colorString.hasPrefix("rgb(") {
                return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            } else {
                return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
            }
        }
        
        // Fallback to black color
        return .black
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
