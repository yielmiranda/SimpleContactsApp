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
    static func fetchContacts() -> [PersonEntity]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
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
}
