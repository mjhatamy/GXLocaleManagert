//
//  PresentationData.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/16/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

public final class PresentationData:NSObject {
    public let strings: PresentationStrings
    
    public init(urlForSecondaryLanguageFile:URL? = nil) {
        self.strings = PresentationStrings.init(urlForSecondaryLanguageFile: urlForSecondaryLanguageFile)
        super.init()
    }
    
    
    func setLocale(_ langCode:String){
        
    }
    
    
}
