//
//  PresentationStrings.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/16/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

public final class PresentationStrings {
    fileprivate static var mdict = [String:String]()
    fileprivate static var ldict = [String:String]()
    public struct cSignUp{
        var WelcomeToMyGix:String { return ldict["Signup.WelcomeToMyGix"] ?? ( mdict["Signup.WelcomeToMyGix"] ?? "")}
    }
    let SignUp = cSignUp()
    
    init(urlForSecondaryLanguageFile:URL? = nil) {
        PresentationStrings.loadLocalization(urlForSecondaryLanguageFile)
    }
    
    class func loadLocalization(_ langFileUrl:URL?){
        let fp = FileManager.default
        
        if let fileUrl = langFileUrl?.path {
            if fp.fileExists(atPath: fileUrl) {
                 PresentationStrings.ldict = NSDictionary(contentsOfFile: fileUrl) as! [String : String]
            }
        }
        
        ///Load Default LangPack from App Bundle
        guard let url = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: "en") else{
            assert(false, "Localizable.string file for main language 'en' is nil")
            return
        }
        PresentationStrings.mdict = NSDictionary(contentsOfFile: url) as! [String : String]
        
        return
    }
}
