//
//  RequestManager.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Task {
    case fetchContacts()
}

typealias SuccessBlock = (_ response: Any) -> Void
typealias FailureBlock = (_ error: NSError) -> Void
typealias CompletionBlock = (_ response: JSON?, _ error: NSError?) -> Void

class RequestManager {
    static let sharedInstance = SessionManager()
    class func perform(task: Task, completion: @escaping CompletionBlock) {
        self.invoke(task: task, completion: completion)
    }
    
    private class func invoke(task: Task, completion: @escaping CompletionBlock) {
        let reqTask: RequestTask = {
            
            switch task {
            case .fetchContacts():
                return RequestTask(urlRequest: Router.fetchContacts())
            }
        }()
        
        reqTask.perform({ (response) in
            let responseJSON = JSON(response)
            print(responseJSON as Any)
            
            completion(responseJSON, nil) 
        }) { (error) in
            print(error.code)
            
            completion(nil, error)
        }
    }
    
}
