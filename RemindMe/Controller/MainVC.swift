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
        AlertService.presentActionSheet(on: self, title: "5 seconds") {
            UNService.shared.requestTimerNotification(with: 5)
        }
    }
    
    @IBAction func dateBtnWasPressed(_ sender: Any) {
        print("Date")
        
        AlertService.presentActionSheet(on: self, title: "Some future time") {
            var components = DateComponents()
            components.second = 0
            
            UNService.shared.requestDateNotification(with: components)
        }
    }
    
    @IBAction func locationBtnWasPressed(_ sender: Any) {
        print("Location")
        AlertService.presentActionSheet(on: self, title: "When I return") {
            print("Location completion")
        }
    }
    
}

