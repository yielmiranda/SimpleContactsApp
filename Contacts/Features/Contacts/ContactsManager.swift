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

enum ContactsLoaderResult {
    case Success, Failure
}

class ContactsManager: NSObject {
    
    //MARK: - Loader
    
    func loadContactsFromRemote(completionHandler: @escaping (_ result: ContactsLoaderResult,
                                _ contacts: [Person]?,
                                _ errorDescription: String?) -> Void) {
        ContactsService.fetchContacts { (json, error) in
            var result = ContactsLoaderResult.Success
            var contacts: [Person]?
            var errorDescription: String?
            
            if let error = error {
                errorDescription = error.localizedDescription
                result = ContactsLoaderResult.Failure
            } else {
                contacts = self.parseContactsFromRemote(withJson: json)
            }
            
            completionHandler(result, contacts, errorDescription)
        }
    }
    
    func loadContactsFromLocal() -> [Person]? {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "PersonEntity",
                                                            in: managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest) as! [PersonEntity]
            guard fetchRawResults.count != 0 else { return nil }
            
            var contacts = [Person]()
            for result in fetchRawResults {
                contacts.append(convertToPersonModel(withPersonEntity: result))
            }
            
            return contacts
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    //MARK: - Parser
    
    func parseContactsFromRemote(withJson json: JSON?) -> [Person] {
        var contacts = [Person]()
        guard json != nil else { return contacts }
        
        let jsonData = json!.dictionary
        guard jsonData != nil else { return contacts }
        
        let persons = jsonData!["person"]?.array
        guard persons != nil else { return contacts }
        
        for person in persons! {
            let personData = person.dictionary
            guard personData != nil else { continue }
            
            let contact = Person()
            contact.firstName = personData!["firstname"]?.string ?? ""
            contact.lastName = personData!["lastname"]?.string ?? ""
            contact.address = personData!["address"]?.string ?? ""
            contact.birthday = personData!["birthday"]?.string ?? ""
            contact.mobileNumber = personData!["mobile_number"]?.string ?? ""
            contact.emailAddress = personData!["email"]?.string ?? ""
            contact.contactPersonName = personData!["contact_person"]?.string ?? ""
            contact.contactPersonNumber = personData!["contact_person_number"]?.string ?? ""
            
            contacts.append(contact)
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
    
    //MARK: - Helpers
    
    private func convertToPersonModel(withPersonEntity entity: PersonEntity) -> Person {
        let person = Person()
        person.firstName = entity.firstName ?? ""
        person.lastName = entity.lastName ?? ""
        person.address = entity.address ?? ""
        person.birthday = entity.birthday ?? ""
        person.mobileNumber = entity.mobileNumber ?? ""
        person.emailAddress = entity.emailAddress ?? ""
        person.contactPersonName = entity.contactPersonName ?? ""
        person.contactPersonNumber = entity.contactPersonNumber ?? ""
        
        return person
    }
}
