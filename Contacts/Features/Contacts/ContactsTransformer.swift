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
    
    //MARK: - Parser
    
    static func transformToPersons(withJson json: JSON?) -> [Person] {
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
    
    //MARK: - Converter
    
    static func convertToPersonModel(withPersonEntity entity: PersonEntity) -> Person {
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
