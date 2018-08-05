//
//  ContactDetailInteractor.swift
//  Contacts
//
//  Created by sprixes on 22/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class ContactsDetailsViewModel {
    
    //MARK: - Properties
    
    static let personLabelsDidChange = Notification.Name("contactDetailsLabelsDidChange")
    static let isLoadingDidChange = Notification.Name("isLoadingDidChange")
    static let errorMessageDidChange = Notification.Name("errorMessageDidChange")
    
    private var manager: ContactsManager!
    
    private var person: Person!
    
    var personLabels: [String]! {
        willSet {
            NotificationCenter.default.post(name: ContactsDetailsViewModel.personLabelsDidChange, object: self, userInfo: [\ContactsDetailsViewModel.personLabels: newValue])
        }
    }
    
    var isLoading: Bool! {
        willSet {
            NotificationCenter.default.post(name: ContactsDetailsViewModel.isLoadingDidChange, object: self, userInfo: [\ContactsDetailsViewModel.isLoading: newValue])
        }
    }
    
    var errorMessage: String! {
        willSet {
            NotificationCenter.default.post(name: ContactsDetailsViewModel.errorMessageDidChange, object: self, userInfo: [\ContactsDetailsViewModel.errorMessage: newValue])
        }
    }
    
    //MARK:  Init
  
    init() {
        self.manager = DefaultContactsManager()
    }
  
    //MARK: - Methods
    
    //MARK: Public
    
    func loadPerson(withId id: Int){
        isLoading = true
    
        let person = ContactsLocalService.fetchPerson(withId: id)
        guard person != nil else {
            onLoadPersonFail()
            return
        }
        
        onLoadPersonSuccess(withPerson: person!)
    }
  
    //MARK: Private
    
    private func onLoadPersonSuccess(withPerson person: Person) {
        isLoading = false
        self.person = person
        
        self.personLabels = ContactsTransformer.convertToContactDetails(withPerson: person)
    }
  
    private func onLoadPersonFail() {
        isLoading = false
        errorMessage = "Failed loading person details"
    }
}
