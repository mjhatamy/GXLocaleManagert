//
//  GXLocaleManager.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit
import Foundation

extension Notification.Name{
    struct GXLocaleManager {
        static let defaultLocaleChanged:Notification.Name = Notification.Name("com.mygix.GXLocaleManager.DefaultLocaleChanged")
    }
}

class GXLocaleManager: NSObject {
    
    public class func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    /**
     * Returns current time with UTC Offset.
     * - parameter utcOffset: UTC Offset to get its time.
     * - parameter locale: String value of Locale identifier to return time string in format of the specified locale. for example: EN or FR. Default value is current App locale.
    */
    public class func getTimeStringFromGMT(_ utcOffset:Double, _ locale:String = GXLocaleManager.languageCode) -> String?{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: locale)
        guard let timeZone = TimeZone(secondsFromGMT: 0 ) else{
            return nil
        }
        formatter.timeZone = timeZone
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + (  utcOffset   * 60 * 60) )
        return formatter.string(from: date)
    }
    
    
    //let localeDirectoryName = "GXLanguagePath"
    class func makeLocaleURL()-> URL?{
        guard let fileUrl = URL.getGXFileURLFor("Localizable.strings", directory: "GXLanguagePath", false) else{
            LOGE("Unable to make Language pack URL for path: Localizable")
            return nil
        }
        return fileUrl
    }
    class func getLocaleUrl() -> URL?{
        UserDefaults.standard.synchronize()
        guard let path = UserDefaults.standard.string(forKey: "GXLanguagePath") else{
            return nil
        }
        
        guard let fileUrl = URL.getGXFileURLFor(path, directory: "GXLanguagePath", false) else{
            LOGE("Unable to get Language pack URL for path:\(path)")
            return nil
        }
        return fileUrl
    }
    
    class var isAppViewDirectionIsRightToLeft:Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    class var isRightToLeftLanguage: Bool{
        let m_languaceCode = GXLocaleManager.languageCode
        if m_languaceCode == "ar" || m_languaceCode == "fa" || m_languaceCode == "he" {
            return true
        }
        return false
    }
    
    class var isPersianBasedLanguage: Bool{
        let m_languaceCode = GXLocaleManager.languageCode
        if m_languaceCode == "ar" || m_languaceCode == "fa" {
            return true
        }
        return false
    }
    
    class var languagePackVersion:Double {
        let m_version = UserDefaults.standard.double(forKey: "GXLanguagePathVersion")
        return m_version
    }
    class func getLocalFileVersion() -> Double?{
        let version = UserDefaults.standard.double(forKey: "GXLanguagePathVersion")
        return version > 0 ? version : nil
    }
    
    class func setLocaleFileUrl(_ fileURL:URL, _ version:Double){
        UserDefaults.standard.set(fileURL.lastPathComponent, forKey: "GXLanguagePath")
        UserDefaults.standard.set(fileURL.lastPathComponent, forKey: "GXLanguagePathVersion")
        UserDefaults.standard.synchronize()
    }
    
    class var languageCode:String {
        get{
            guard let res =  UserDefaults.standard.string(forKey: "GXLanguageCode")  else{
                let currentLocale = Locale.current.languageCode ?? "en"
                UserDefaults.standard.set(currentLocale, forKey: "GXLanguageCode")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name.GXLocaleManager.defaultLocaleChanged, object: nil, userInfo: ["languageCode": self.languageCode])
                return currentLocale
            }
            return res
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "GXLanguageCode")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.GXLocaleManager.defaultLocaleChanged, object: nil, userInfo: ["languageCode": self.languageCode])
        }
    }
    
    /// This handler will be called after every change in language. You can change it to handle minor localization issues in user interface.
    @objc static var updateHandler: () -> Void = {
        return
    }
    
    /// Returns Base localization identifier
    @objc class var base: String {
        return "Base"
    }

    /**
     Iterates all localization done by developer in app. It can be used to show available option for user.
     
     Key in returned dictionay can be used as identifer for passing to `apply(identifier:)`.
     
     Value is localized name of language according to current locale and should be shown in user interface.
     
     - Note: First item will be `Base` localization.
     
     - Return: A dictionary that keys are language identifiers and values are localized language name
     */
    @objc class var availableLocalizations: [String: String] {
        let keys = Bundle.main.localizations
        
        let vals = keys.map({ Locale.userPreferred.localizedString(forIdentifier: $0) ?? $0 })
        return [String: String].init(zip(keys, vals), uniquingKeysWith: { v, _ in v })
    }
    
    
    /**
     This handler will be called to get root viewController to initialize.
     
     - Important: Either this property or storyboard identifier's of root view controller must be set.
     */
    @objc static var rootViewController: ((_ window: UIWindow) -> UIViewController?)? = nil
    
    /**
     This handler will be called to get localized string before checking bundle. Allows custom translation for system strings.
     
     - Important: **DON'T USE** `NSLocalizedString()` inside the closure body. Use a `Dictionary` instead.
     */
    @objc static var customTranslation: ((_ key: String) -> String?)? = nil
    
    /**
     Reloads all windows to apply orientation changes in user interface.
     
     - Important: Either rootViewController must be set or storyboardIdentifier of root viewcontroller
     in Main.storyboard must set to a string.
     */
    internal class func reloadWindows(animated: Bool = true) {
        let windows = UIApplication.shared.windows
        for window in windows {
            if let rootViewController = self.rootViewController?(window) {
                window.rootViewController = rootViewController
            } else if let storyboard = window.rootViewController?.storyboard, let id = window.rootViewController?.value(forKey: "storyboardIdentifier") as? String {
                window.rootViewController = storyboard.instantiateViewController(withIdentifier: id)
            }
            for view in (window.subviews) {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
        if animated {
            windows.first.map {
                UIView.transition(with: $0, duration: 0.55, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
    }
    
    
    /**
     Overrides system-wide locale in application setting.
     
     - Parameter identifier: Locale identifier to be applied, e.g. `en`, `fa`, `de_DE`, etc.
     */
    private class func setLocale(identifiers: [String]) {
        UserDefaults.standard.set(identifiers, forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    /// Removes user preferred locale and resets locale to system-wide.
    private class func removeLocale() {
        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        
        // These keys are used in maximbilan/ios_language_manager and may conflict with this implementation.
        // We remove them here.
        UserDefaults.standard.removeObject(forKey: "AppleTextDirection")
        UserDefaults.standard.removeObject(forKey: "NSForceRightToLeftWritingDirection")
        
        UserDefaults.standard.synchronize()
    }
    
    /**
     Overrides system-wide locale in application and reloads interface.
     
     - Parameter identifier: Locale identifier to be applied, e.g. `en` or `fa_IR`. `nil` value will change locale to system-wide.
     */
    @objc class func apply(locale: Locale?, animated: Bool = true) {
        //let semantic: UISemanticContentAttribute
        //if let locale = locale {
            //setLocale(identifiers: [locale.identifier])
            //semantic = locale.isRTL ? .forceRightToLeft : .forceLeftToRight
        //} else {
           // removeLocale()
            //semantic = Locale.baseLocale.isRTL ? .forceRightToLeft : .forceLeftToRight
        //}
        Locale.cachePreffered = nil
        //UIView.appearance().semanticContentAttribute = semantic
        //UITableView.appearance().semanticContentAttribute = semantic
        //UITableViewCell.appearance().semanticContentAttribute = semantic
        //UISwitch.appearance().semanticContentAttribute = semantic
        
        //reloadWindows(animated: animated)
        NotificationCenter.default.post(name: NSNotification.Name.GXLocaleManager.defaultLocaleChanged, object: nil, userInfo: ["Locale": locale ?? Locale.current])
        updateHandler()
    }
    
    /**
     Overrides system-wide locale in application and reloads interface.
     
     - Parameter identifier: Locale identifier to be applied, e.g. `en` or `fa_IR`. `nil` value will change locale to system-wide.
     */
    @objc class func apply(identifier: String?, animated: Bool = true, fileUrl:URL, version:Double) {
        //let locale = identifier.map(Locale.init(identifier:))
        //setLocale(identifiers: [identifier ?? "en"])
        setLocaleFileUrl(fileUrl, version)
        
        GXLocaleManager.languageCode = identifier ?? "en"
        //apply(locale: locale, animated: animated)
    }
    
    /**
     This method MUST be called in `application(_:didFinishLaunchingWithOptions:)` method.
     */
    @objc public class func setup() {
        // Allowing to update localized string on the fly.
        //Bundle.swizzleMethod(#selector(Bundle.localizedString(forKey:value:table:)),
                             //with: #selector(Bundle.mn_custom_localizedString(forKey:value:table:)))
        // Enforcing userInterfaceLayoutDirection based on selected locale. Fixes pop gesture in navigation controller.
        //UIApplication.swizzleMethod(#selector(getter: UIApplication.userInterfaceLayoutDirection),
                                    //with: #selector(getter: UIApplication.mn_custom_userInterfaceLayoutDirection))
        // Enforcing currect alignment for labels and texts which has `.natural` direction.
        //UILabel.swizzleMethod(#selector(UILabel.layoutSubviews), with: #selector(UILabel.mn_custom_layoutSubviews))
        //UITextField.swizzleMethod(#selector(UITextField.layoutSubviews), with: #selector(UITextField.mn_custom_layoutSubviews))
    }
}


extension UIApplication {
    @objc var mn_custom_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get {
            let _ = self.mn_custom_userInterfaceLayoutDirection // DO NOT OPTIMZE!
            return Locale._userPreferred.isRTL ? .rightToLeft : .leftToRight
        }
    }
}


internal extension NSObject {
    @discardableResult
    class func swizzleMethod(_ selector: Selector, with withSelector: Selector) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getInstanceMethod(self, selector)
        swizzledMethod = class_getInstanceMethod(self, withSelector)
        
        if (originalMethod != nil && swizzledMethod != nil) {
            if class_addMethod(self, selector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
                class_replaceMethod(self, withSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            return true
        }
        return false
    }
    
    @discardableResult
    class func swizzleStaticMethod(_ selector: Selector, with withSelector: Selector) -> Bool {
        
        var originalMethod: Method?
        var swizzledMethod: Method?
        
        originalMethod = class_getClassMethod(self, selector)
        swizzledMethod = class_getClassMethod(self, withSelector)
        
        if (originalMethod != nil && swizzledMethod != nil) {
            if class_addMethod(self, selector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
                class_replaceMethod(self, withSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            return true
        }
        return false
    }
}
