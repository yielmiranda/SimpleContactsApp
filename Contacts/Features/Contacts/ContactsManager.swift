//
//  ContactsManager.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

protocol ContactsManager {
    func loadContacts(completionHandler: @escaping ContactsLoaderCompletionBlock)
}

enum Result {
    case Success, Error
}

typealias ContactsServiceLoaderCompletionBlock = (_ contacts: [Person]?, _ errorDescription: String?) -> Void
typealias ContactsLoaderCompletionBlock =  (_ result: Result, _ contacts: [Person]?,
                                            _ errorDescription: String?) -> Void

class DefaultContactsManager: ContactsManager {
    
    //MARK: - Loader
    
    func loadContacts(completionHandler: @escaping ContactsLoaderCompletionBlock) {
        var result = Result.Success
        var contacts: [Person]?
        var errorDescription: String?
        
        contacts = loadContactsFromLocal()
        guard contacts == nil else {
            completionHandler(result, contacts, errorDescription)
            return
        }
        
        loadContactsFromRemote(completionHandler: { (remoteContacts, remoteError) in
            if let error = remoteError {
                result = .Error
                errorDescription = error
            } else if let remoteContacts = remoteContacts {
                for contact in remoteContacts {
                    ContactsLocalService.savePersonEntityToCoreData(withPerson: contact)
                }
                
                contacts = remoteContacts
            }
            
            completionHandler(result, contacts, errorDescription)
        })
    }
    
    private func loadContactsFromRemote(completionHandler: @escaping ContactsServiceLoaderCompletionBlock) {
        ContactsRemoteService.fetchContacts { (json, error) in
            var contacts: [Person]?
            var errorDescription: String?
            
            if let error = error {
                errorDescription = error.localizedDescription
            } else {
                contacts = ContactsTransformer.convertToPersons(withJson: json)
            }
            
            completionHandler(contacts, errorDescription)
        }
    }
    
    private func loadContactsFromLocal() -> [Person]? {
        let contactEntities = ContactsLocalService.fetchContacts()
        guard contactEntities != nil else { return nil }
        
        var contacts = [Person]()
        for entity in contactEntities! {
            contacts.append(ContactsTransformer.convertToPerson(withEntity: entity))
        }
        
        return contacts
    }
}
