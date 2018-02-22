//
//  ContactsInteractor.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

@objc protocol ContactsView {
    @objc optional func setContactList(withContacts contacts: [Person])
    @objc optional func showActivityIndicator()
    @objc optional func hideActivityIndicator()
    @objc optional func showAlert(withMessage message: String)
}

class ContactsInteractor: NSObject {

    //MARK: - Properties
    
    var view: ContactsView!
    var manager: ContactsManager!
    
    //MARK: - Initializer
    
    func initContactsInteractor(withView view: ContactsView) {
        self.view = view
        self.manager = ContactsManager()
    }
    
    //MARK: - Methods
    
    func loadContacts() {
        if let contacts = manager.loadContactsFromLocal() {
            view.setContactList?(withContacts: contacts)
            
            return
        }
        
        view.showActivityIndicator?()
        manager.loadContactsFromRemote(completionHandler: { (result, contacts, error) in
            DispatchQueue.main.async {
                self.view.hideActivityIndicator?()
                
                if result == .Success {
                    for contact in contacts! {
                        self.manager.savePersonEntityToCoreData(withPerson: contact)
                    }
                    
                    self.view.setContactList?(withContacts: contacts!)
                } else {
                    self.view.showAlert?(withMessage: error!)
                }
            }
        })
    }
}
