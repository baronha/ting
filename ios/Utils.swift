//
//  Utils.swift
//  Ting
//
//  Created by BẢO HÀ on 28/06/2023.
//

import UIKit


class Utils {
    class func hexStringToColor(_ stringToConvert: String?) -> UIColor? {        
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
    
    private init() {
        fatalError("Static class 'Utils' cannot be instantiated!")
    }
}
