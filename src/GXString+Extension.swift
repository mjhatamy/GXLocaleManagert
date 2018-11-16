//
//  GXString+Extension.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension String {
    /**
     Returns a String object initialized by using a given format string as a template into which
     the remaining argument values are substituted according to user preferred locale information.
     */
    func localizedFormat(_ args: CVarArg...) -> String {
        if args.isEmpty {
            return self
        }
        return String(format: self, locale: Locale.userPreferred, arguments: args)
    }
}
