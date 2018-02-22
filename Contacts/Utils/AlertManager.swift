//
//  AlertManager.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    //MARK: - Properties
    
    static let sharedAlert = AlertManager()
    
    private var alertController: UIAlertController!

    //MARK: - Methods
    
    func displayStandardAlert(withViewController vc: UIViewController, title: String, andMessage message: String) {
        if alertController != nil {
            dismissAlert()
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
    
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func dismissAlert() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
