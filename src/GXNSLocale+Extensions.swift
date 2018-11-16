//
//  GXNSLocale+Extensions.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension NSLocale {
    /**
     Locale selected by user.
     */
    @objc class var userPreferred: Locale {
        return Locale.userPreferred
    }
    
    /**
     Checking the locale writing direction is right to left.
     */
    @objc var isRTL: Bool {
        return (self as Locale).isRTL
    }
    

    fileprivate static func swizzle(selector: Selector, with replacement: Selector) {
        let originalSelector = selector
        let swizzledSelector = replacement
        
        if let swizzledMethod = class_getClassMethod(self, swizzledSelector), let originalMethod = class_getClassMethod(self, originalSelector) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    
    
}
