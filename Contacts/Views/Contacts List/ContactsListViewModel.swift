//
//  ContactsInteractor.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class ContactsListViewModel {

    //MARK: - Properties
    
    static let contactsListDidChange = Notification.Name("contactsListDidChange") //can be static //can be moved to other class
    static let isLoadingDidChange = Notification.Name("isLoadingDidChange")
    static let errorMessageDidChange = Notification.Name("errorMessageDidChange")
    
    private var manager: ContactsManager!
    
    var contactsList: [Person]! {
        willSet {
            NotificationCenter.default.post(name: ContactsListViewModel.contactsListDidChange, object: self, userInfo: [\ContactsListViewModel.contactsList: newValue])
        }
    }
    
    var isLoading: Bool! {
        willSet {
            NotificationCenter.default.post(name: ContactsListViewModel.isLoadingDidChange, object: self, userInfo: [\ContactsListViewModel.isLoading: newValue])
        }
    }
    
    var errorMessage: String! {
        willSet {
            NotificationCenter.default.post(name: ContactsListViewModel.errorMessageDidChange, object: self, userInfo: [\ContactsListViewModel.errorMessage: newValue])
        }
    }
    
    //MARK: - Initializer
    
    init() {
        self.manager = DefaultContactsManager()
    }
    
    //MARK: - Methods
    
    //MARK: - Public
    
    func loadContacts() {
        isLoading = true
        
        manager.loadContacts { (result, contacts, error) in
            self.isLoading = false
            
            if result == .Success {
                self.onLoadContactsSuccess(withContacts: contacts!)
            } else {
                self.onLoadContactsFail(withMessage: error!)
            }
        }
    }
    
    //MARK: Private
    
    private func onLoadContactsSuccess(withContacts contacts: [Person]) {
        contactsList = contacts
    }
    
    private func onLoadContactsFail(withMessage message: String) {
        errorMessage = message
    }
}
