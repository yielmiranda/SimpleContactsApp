//
//  ServiceManager.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

final class ContactsRemoteService: RequestManager {
    static func fetchContacts(completionBlock: @escaping CompletionBlock) {
        perform(task: .fetchContacts()) { (result, error) in
            print("Result = \(String(describing: result))")
            
            completionBlock(result, error)
        }
    }
}
