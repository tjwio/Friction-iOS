//
//  UIColor+HexRGB.swift
//  friction
//
//  Created by Tim Wong on 4/13/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(hexColor: UInt, alpha: CGFloat = 1.0) {
        self.init(red: ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0,
                  green: ((CGFloat)((hexColor & 0x00FF00) >>  8))/255.0,
                  blue: ((CGFloat)((hexColor & 0x0000FF) >>  0))/255.0,
                  alpha: alpha);
    }
    
    struct Grayscale {
        static var darker: UIColor {
            return UIColor(hexColor: 0x3D3D3D)
        }
        
        static var dark: UIColor {
            return UIColor(hexColor: 0x656A6F)
        }
        
        static var backgroundLight: UIColor {
            return UIColor(hexColor: 0xF5F7FA)
        }
        
        static var medium: UIColor {
            return UIColor(hexColor: 0x7D7D7D)
        }
        
        static var light: UIColor {
            return UIColor(hexColor: 0xA7ADB6)
        }
        
        static var lighter: UIColor {
            return UIColor(hexColor: 0xD8D8D8)
        }
        
        static var lightest: UIColor {
            return UIColor(hexColor: 0xFBFCFD)
        }
        
        static var placeholderColor: UIColor {
            return UIColor(hexColor: 0xC6C6C6)
        }
    }
    
    struct Blue {
        static var lighter: UIColor {
            return UIColor(hexColor: 0xC4DDFF)
        }
        
        static var normal: UIColor {
            return UIColor(hexColor: 0x77B0FD)
        }
        
        static var darker: UIColor {
            return UIColor(hexColor: 0x658DF8)
        }
    }
    
    struct Green {
        static var normal: UIColor {
            return UIColor(hexColor: 0x3FC380)
        }
    }
    
    struct Red {
        static var normal: UIColor {
            return UIColor(hexColor: 0xD64541)
        }
        
        static var darker: UIColor {
            return UIColor(hexColor: 0xC0392B)
        }
        
        static var light: UIColor {
            return UIColor(hexColor: 0xFF7D7D)
        }
    }
    
    struct Pink {
        static var normal: UIColor {
            return UIColor(hexColor: 0xFF6666)
        }
    }
    
    struct Yellow {
        static var normal: UIColor {
            return UIColor(hexColor: 0xF4D03F)
        }
    }
    
    struct Poll {
        static var red: UIColor {
            return UIColor(hexColor: 0xFF8787)
        }
        
        static var orange: UIColor {
            return UIColor(hexColor: 0xF9B598)
        }
        
        static var yellow: UIColor {
            return UIColor(hexColor: 0xFFD97F)
        }
        
        static var pink: UIColor {
            return UIColor(hexColor: 0xFF89C0)
        }
        
        static var purple: UIColor {
            return UIColor(hexColor: 0xA7ABFF)
        }
        
        static let all = [red, orange, purple, pink]
    }
    
    class func pollColor(index: Int) -> UIColor {
        return Poll.all[index % Poll.all.count]
    }
}
