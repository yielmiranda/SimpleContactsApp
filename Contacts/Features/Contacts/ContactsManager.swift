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

enum Result {
    case Success, Error
}

typealias ContactsLoaderCompletionBlock = (_ contacts: [Person]?, _ errorDescription: String?) -> Void

class ContactsManager: NSObject {
    
    //MARK: - Loader
    
    func loadContacts(completionHandler: @escaping (_ result: Result,
                        _ contacts: [Person]?,
                        _ errorDescription: String?) -> Void) {
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
                    self.savePersonEntityToCoreData(withPerson: contact)
                }
                
                contacts = remoteContacts
            }
            
            completionHandler(result, contacts, errorDescription)
        })
    }
    
    private func loadContactsFromRemote(completionHandler: @escaping ContactsLoaderCompletionBlock) {
        ContactsRemoteService.fetchContacts { (json, error) in
            var contacts: [Person]?
            var errorDescription: String?
            
            if let error = error {
                errorDescription = error.localizedDescription
            } else {
                contacts = ContactsTransformer.transformToPersons(withJson: json)
            }
            
            completionHandler(contacts, errorDescription)
        }
    }
    
    private func loadContactsFromLocal() -> [Person]? {
        let contactEntities = ContactsLocalService.fetchContacts()
        guard contactEntities != nil else { return nil }
        
        var contacts = [Person]()
        for entity in contactEntities! {
            contacts.append(ContactsTransformer.convertToPersonModel(withPersonEntity: entity))
        }
        
        return contacts
    }
    
    //MARK: - Saver
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var managedObjectContext: NSManagedObjectContext {
        get {
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    func savePersonEntityToCoreData(withPerson person: Person) {
        let personEntity =  NSEntityDescription.insertNewObject(forEntityName: "PersonEntity", into: managedObjectContext) as! PersonEntity
        
        personEntity.firstName = person.firstName
        personEntity.lastName = person.lastName
        personEntity.address = person.address
        personEntity.birthday = person.birthday
        personEntity.mobileNumber = person.mobileNumber
        personEntity.emailAddress = person.emailAddress
        personEntity.contactPersonName = person.contactPersonName
        personEntity.contactPersonNumber = person.contactPersonNumber
        
        do {
            try managedObjectContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
