//
//  GXNSNumber+Extension.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension NSNumber {
    /**
     Returns localized formatted number with maximum fraction digit according to `precision`.
     
     - Parameter precision: The maximum number of digits after the decimal separator allowed.
     - Parameter style: The number style.
     */
    @objc func localized(precision: Int = 0, style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = precision
        formatter.numberStyle = style
        formatter.locale = Locale.userPreferred
        return formatter.string(from: self)!
    }
}
