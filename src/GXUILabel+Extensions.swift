
//
//  GXUILabel.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension UILabel {
    private struct AssociatedKeys {
        static var originalAlignment = "lm_originalAlignment"
        static var forcedAlignment = "lm_forcedAlignment"
    }
    
    var originalAlignment: NSTextAlignment? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.originalAlignment) as? Int).flatMap(NSTextAlignment.init(rawValue:))
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.originalAlignment,
                    newValue.rawValue as NSNumber,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    var forcedAlignment: NSTextAlignment? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.forcedAlignment) as? Int).flatMap(NSTextAlignment.init(rawValue:))
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.forcedAlignment,
                    newValue.rawValue as NSNumber,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    @objc internal func mn_custom_layoutSubviews() {
        if originalAlignment == nil {
            originalAlignment = self.textAlignment
        }
        
        if let forcedAlignment = forcedAlignment {
            self.textAlignment = forcedAlignment
        } else if originalAlignment == .natural {
            self.textAlignment = Locale._userPreferred.isRTL ? .right : .left
        }
        
        self.mn_custom_layoutSubviews()
    }
}
