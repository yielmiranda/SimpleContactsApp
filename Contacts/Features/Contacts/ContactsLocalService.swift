//
//  ContactsLocalService.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 22/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import CoreData

final class ContactsLocalService: NSObject {
    
    //MARK: - Properties
    
    static let managedObjectContext = CoreDataManager.managedObjectContext
    
    //MARK: - Methods
    
    //MARK: Loader
    
    static func fetchContacts() -> [PersonEntity]? {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "PersonEntity",
                                                            in: managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest) as! [PersonEntity]
            guard fetchRawResults.count != 0 else { return nil }
            
            return fetchRawResults
        } catch let error {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    static func fetchPerson(withId id: Int) -> Person? {
        var person: Person?
        let entityDescription =  NSEntityDescription.entity(forEntityName: "PersonEntity",
                                                            in: managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest) as! [PersonEntity]
            let filteredResults = fetchRawResults.filter {
                $0.id == id
            }
            guard filteredResults.count != 0 else { return person }
            
            person = ContactsTransformer.convertToPerson(withEntity: filteredResults.first!)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return person
    }
    
    //MARK: Saver
    
    static func savePersonEntityToCoreData(withPerson person: Person) {
        let personEntity =  NSEntityDescription.insertNewObject(forEntityName: "PersonEntity", into: managedObjectContext) as! PersonEntity
        
        personEntity.id = Int64(person.id)
        personEntity.name = person.name
        personEntity.address = person.address
        personEntity.username = person.username
        personEntity.mobileNumber = person.mobileNumber
        personEntity.emailAddress = person.emailAddress
        personEntity.website = person.website
        
        do {
            try managedObjectContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
