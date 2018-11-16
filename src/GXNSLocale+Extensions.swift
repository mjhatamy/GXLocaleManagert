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
}
