//
//  ContactsInteractor.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

protocol DefaultContactsListInteractor {
    func loadContacts()
}

class ContactsListInteractor: DefaultContactsListInteractor {

    //MARK: - Properties
    
    var view: ContactsView!
    var manager: ContactsManager!
    
    //MARK: - Initializer
    
    init(withView view: ContactsView) {
        self.view = view
        self.manager = ContactsManager()
    }
    
    //MARK: - Methods
    
    func loadContacts() {
        view.showActivityIndicator()
        
        manager.loadContacts { (result, contacts, error) in
            DispatchQueue.main.async {
                self.view.hideActivityIndicator()
                
                if result == .Success {
                    self.view.setContactList(withContacts: contacts!)
                } else {
                    self.view.showAlert(withMessage: error!)
                }
            }
        }
    }
}
