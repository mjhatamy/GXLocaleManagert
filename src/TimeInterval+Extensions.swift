//
//  TimeInterval+Extensions.swift
//  GXNaviChatUI
//
//  Created by Majid Hatami Aghdam on 2/19/19.
//  Copyright © 2019 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension TimeInterval {
    var stringFromTimeInterval:String {
        
        let time:NSInteger = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }else{
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }
    }
}
