//
//  ViewController.swift
//  GXLocaleManager
//
//  Created by Majid Hatami Aghdam on 11/15/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        let currentLangCode = Locale.current.languageCode ?? "en"
        
        if currentLangCode == "fa"{
            GXLocaleManager.apply(identifier: "tr", animated: false)
        }else if currentLangCode == "tr"{
            GXLocaleManager.apply(identifier: "en", animated: false)
        }
        else if currentLangCode == "en"{
            GXLocaleManager.apply(identifier: "fa", animated: false)
        }
        
        
    }
}

