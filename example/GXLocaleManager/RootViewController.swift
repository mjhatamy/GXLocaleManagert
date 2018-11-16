//
//  RootViewController.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit
import Foundation

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let p = PresentationData.init()
        self.navigationItem.title = p.strings.SignUp.WelcomeToMyGix
        
    }

}


public final class GXKeyValueClass: NSObject{
    var dict = [String:String]()


    var sample:String { return dict["sample"] ?? "" }
    
    public override init() {
        super.init()

        NSLog("after  value:\(self.sample)")
    }
}

