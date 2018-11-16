//
//  GXBundle+Extensions.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//
import Foundation


extension Bundle {
    private static var savedLanguageNames: [String: String] = [:]
    
    private func languageName(for lang: String) -> String? {
        if let langName = Bundle.savedLanguageNames[lang] {
            return langName
        }
        let langName = Locale(identifier: "en").localizedString(forLanguageCode: lang)
        Bundle.savedLanguageNames[lang] = langName
        return langName
    }
    
    fileprivate func resourcePath(for locale: Locale) -> String? {
        /*
         After swizzling localizedString() method, this procedure will be used even for system provided frameworks.
         Thus we shall try to find appropriate localization resource in current bundle, not main.
         
         Apple's framework
         
         Trying to find appropriate lproj resource in the bundle ordered by:
         1. Locale identifier (e.g: en_GB, fa_IR)
         2. Locale language code (e.g en, fa)
         3. Locale language name (e.g English, Japanese), used as resource name in Apple system bundles' localization (Foundation, UIKit, ...)
         */
        if let path = self.path(forResource: locale.identifier, ofType: "lproj") {
            return path
        } else if let path = locale.languageCode.flatMap(languageName(for:)).flatMap({ self.path(forResource: $0, ofType: "lproj") }) {
            return path
        } else if let path = languageName(for: locale.identifier).flatMap({ self.path(forResource: $0, ofType: "lproj") }) {
            return path
        } else {
            return nil
        }
    }
    
    @objc func mn_custom_localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let customString = GXLocaleManager.customTranslation?(key) {
            return customString
        }
        
        /*
         Trying to find lproj resource first in user preferred locale, then system-wide current locale, and finally "Base"
         */
        let bundle: Bundle
        if let path = resourcePath(for: Locale._userPreferred) {
            bundle = Bundle(path: path)!
        } else if let path = resourcePath(for: Locale.current) {
            bundle = Bundle(path: path)!
        } else if let path = self.path(forResource: GXLocaleManager.base, ofType: "lproj") {
            bundle = Bundle(path: path)!
        } else {
            if let value = value, !value.isEmpty {
                return value
            } else {
                bundle = self
            }
        }
        return bundle.mn_custom_localizedString(forKey: key, value: value, table: tableName)
    }
}


///    Custom subclass to enable on-the-fly Bundle.main language change
public final class LocalizedBundle: Bundle {
    ///    Overrides system method and enforces usage of particular .lproj translation bundle
    override public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = Bundle.main.localizedBundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
}


public extension Bundle {
    private struct AssociatedKeys {
        static var b = "LocalizedMainBundle"
    }
    
    fileprivate var localizedBundle: Bundle? {
        get {
            //    warning: Make sure this object you are fetching really exists
            return objc_getAssociatedObject(self, &AssociatedKeys.b) as? Bundle
        }
    }
    
    /// Loads the translations for the given language code.
    ///
    /// - Parameter code: two-letter ISO 639-1 language code
    public static func enforceLanguage(_ code: String) {
        guard let path = Bundle.main.path(forResource: code, ofType: "lproj") else { return }
        guard let bundle = Bundle(path: path) else { return }
        
        //    prepare translated bundle for chosen language and
        //    save it as property of the Bundle.main
        objc_setAssociatedObject(Bundle.main, &AssociatedKeys.b, bundle, .OBJC_ASSOCIATION_RETAIN)
        
        //    now override class of the main bundle (only once during the app lifetime)
        //    this way, `localizedString(forKey:value:table)` method in our subclass above will actually be called
        DispatchQueue.once(token: AssociatedKeys.b)  {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
    }
    
    
    ///    Removes the custom bundle
    public static func clearInAppOverrides() {
        objc_setAssociatedObject(Bundle.main, &AssociatedKeys.b, nil, .OBJC_ASSOCIATION_RETAIN)
    }
}

/*
 Credits:
 https://github.com/future-challenger/Swift3.0/tree/master/GCD
 */

public extension DispatchQueue {
    private static var onceTracker = [String]()
    
    ///    Execute the given `block` only once during app's lifecycle
    public class func once(token: String, block: (Void) -> Void) {
        objc_sync_enter(self);
        defer {
            objc_sync_exit(self)
        }
        
        if onceTracker.contains(token) { return }
        onceTracker.append(token)
        //block(Void)
    }
}
