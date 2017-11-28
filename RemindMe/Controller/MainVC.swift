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
        CoreLocationService.shared.authorize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterRegion), name: NSNotification.Name("internalNotification.enteredRegion"), object: nil)
        // internalNotification.handleAction
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction(_:)), name: NSNotification.Name("internalNotification.handleAction"), object: nil)
    }
    
    @objc func didEnterRegion() {
        UNService.shared.requestLocationNotification()
    }
    
    @objc func handleAction(_ sender: Notification) {
        guard let action = sender.object as? NotificationActionID else { return }
        
        switch action {
        case .timer:
            print("Timer logic was run")
        case .date:
            print("Date logic was run")
        case .location:
            print("Location logic was run")
            changeBackgroundColor()
        }
    }
    
    func changeBackgroundColor() {
        view.backgroundColor = #colorLiteral(red: 0.6619830666, green: 0.499614244, blue: 1, alpha: 1)
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
            CoreLocationService.shared.updateLocation()
        }
    }
    
}

extension MainVC: UIPopoverPresentationControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}

