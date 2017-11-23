//
//  MainVC.swift
//  RemindMe
//
//  Created by Dan Lindsay on 2017-11-23.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNService.shared.authorize()
    }
    
    @IBAction func timeBtnWasPressed(_ sender: Any) {
        print("timer")
        UNService.shared.requestTimerNotification(with: 5)
    }
    
    @IBAction func dateBtnWasPressed(_ sender: Any) {
        print("Date")
    }
    
    @IBAction func locationBtnWasPressed(_ sender: Any) {
        print("Location")
    }
    
}

