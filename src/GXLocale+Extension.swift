//
//  GXLocale+Extension.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension Locale {
    /**
     Caching prefered local to speed up as this method is called frequently in swizzled method.
     Must be set to nil when `AppleLanguages` has changed.
     */
    static var cachePreffered: Locale?
    
    static var _userPreferred: Locale {
        if let cachePreffered = cachePreffered {
            return cachePreffered
        }
        
        cachePreffered = userPreferred
        return cachePreffered!
    }
    
    static var baseLocale: Locale {
        let base = Locale.preferredLanguages.first(where: { $0 != GXLocaleManager.base }) ?? "en_US"
        return Locale.init(identifier: base)
    }
    
    /**
     Locale selected by user.
     */
    static var userPreferred: Locale {
        let preffered = Locale.preferredLanguages.first.map(Locale.init(identifier:)) ?? Locale.current
        let localizations = Bundle.main.localizations.map( { $0.replacingOccurrences(of: "-", with: "_") } )
        let preferredId = preffered.identifier.replacingOccurrences(of: "-", with: "_")
        return localizations.contains(preferredId) ? preffered : baseLocale
    }
    
    /**
     Checking the locale writing direction is right to left.
     */
    public var isRTL: Bool {
        return Locale.characterDirection(forLanguage: self.languageCode!) == .rightToLeft
    }
}
