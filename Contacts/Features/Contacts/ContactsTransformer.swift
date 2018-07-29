//
//  ContactsTransformer.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 22/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import SwiftyJSON

final class ContactsTransformer: NSObject {
    static func convertToPersons(withJson json: JSON?) -> [Person] {
        var contacts = [Person]()
        guard json != nil else { return contacts }
        
        let personData = json!.dictionary
        guard personData != nil else { return contacts }
        
        var contact = Person()
        contact.id = personData!["id"]?.int ?? 1
        contact.name = personData!["name"]?.string ?? ""
        contact.username = personData!["username"]?.string ?? ""
        contact.mobileNumber = personData!["phone"]?.string ?? ""
        contact.emailAddress = personData!["email"]?.string ?? ""
        contact.website = personData!["website"]?.string ?? ""
        
        if let addressData = personData!["address"]?.dictionary {
            contact.address = addressData["street"]?.string ?? ""
            contact.address += addressData["suite"]?.string ?? ""
            contact.address += addressData["city"]?.string ?? ""
        }
        
        contacts.append(contact)
        
        return contacts
    }
    
    static func convertToPerson(withEntity entity: PersonEntity) -> Person {
        var person = Person()
        person.id = Int(entity.id)
        person.name = entity.name ?? ""
        person.username = entity.username ?? ""
        person.address = entity.address ?? ""
        person.mobileNumber = entity.mobileNumber ?? ""
        person.emailAddress = entity.emailAddress ?? ""
        person.website = entity.website ?? ""
        
        return person
    }
    
    static func convertToContactDetails(withPerson person: Person) -> [String] {
        return [person.name,
                person.username,
                person.address,
                person.mobileNumber,
                person.emailAddress,
                person.website]
    }
    
}
