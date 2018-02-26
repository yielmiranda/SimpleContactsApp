//
//  ContactsInteractor.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

protocol ContactsListInteractor {
    func loadContacts()
}

class DefaultContactsListInteractor: ContactsListInteractor {

    //MARK: - Properties
    
    var view: ContactsView!
    var manager: ContactsManager!
    
    //MARK: - Initializer
    
    init(withView view: ContactsView) {
        self.view = view
        self.manager = DefaultContactsManager()
    }
    
    //MARK: - Methods
    
    //MARK: - Public
    
    func loadContacts() {
        view.showActivityIndicator()
        
        manager.loadContacts { (result, contacts, error) in
            if result == .Success {
                self.onLoadContactsSuccess(withContacts: contacts!)
            } else {
                self.onLoadContactsFail(withMessage: error!)
            }
        }
    }
    
    //MARK: Private
    
    private func onLoadContactsSuccess(withContacts contacts: [Person]) {
        DispatchQueue.main.async {
            self.view.hideActivityIndicator()
            self.view.setContactList(withContacts: contacts)
        }
    }
    
    private func onLoadContactsFail(withMessage message: String) {
        DispatchQueue.main.async {
            self.view.hideActivityIndicator()
            self.view.showAlert(withMessage: message)
        }
    }
}
