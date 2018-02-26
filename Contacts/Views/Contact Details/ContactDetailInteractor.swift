//
//  ContactDetailInteractor.swift
//  Contacts
//
//  Created by sprixes on 22/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

protocol ContactsDetailsInteractor {
    func loadPerson(withId id: Int)
}

class DefaultContactDetailsInteractor: ContactsDetailsInteractor {
    
    //MARK: - Properties
    
    var view: ContactsDetailView!
    var manager: ContactsManager!
    
    //MARK:  Init
  
    init(view: ContactsDetailView) {
        self.view = view
        self.manager = DefaultContactsManager()
    }
  
    //MARK: - Methods
    
    //MARK: Public
    
    func loadPerson(withId id: Int){
        view.showLoading()
    
        let person = ContactsLocalService.fetchPerson(withId: id)
        guard person != nil else {
            onLoadPersonFail()
            return
        }
        
        onLoadPersonSuccess(withPerson: person!)
    }
  
    //MARK: Private
    
    private func onLoadPersonSuccess(withPerson person: Person) {
        view.hideLoading()
        view.setContactDetails(withPerson: person)
        
        let contactDetailsLabels = ContactsTransformer.convertToContactDetails(withPerson: person)
        view.setupContactDetailsList(withLabels: contactDetailsLabels)
    }
  
    private func onLoadPersonFail() {
        view.hideLoading()
        view.showAlert(withMessage: "Failed loading person details")
    }
}
