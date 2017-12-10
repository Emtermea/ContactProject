//
//  ViewController.swift
//  ContactProject
//
//  Created by Emmanuelle TERMEAU on 12/10/17.
//  Copyright © 2017 Emmanuelle TERMEAU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var contactManager = ContactManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactManager.getDataWith { (result) in
            print(result)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

