//
//  APIManager.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case fetchContacts()
    
    var baseURL: String {
        return "https://cpsanpedro.000webhostapp.com/cpsanpedro/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchContacts:
            return .get
        }
    }
    
    struct Endpoint {
        static let fetchContacts = "sample.json"
    }
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case .fetchContacts():
                return (Router.Endpoint.fetchContacts, nil)
            }
        }()
        
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent("\(result.path)"))
        urlRequest.httpMethod = method.rawValue
        
        switch method.rawValue {
        case HTTPMethod.get.rawValue:
            //if you need to do something
             break
            
        default:
            //if you need to do something
             break
        }
        
        return urlRequest
    }
}

class RequestTask {
    private(set) var urlRequest: URLRequestConvertible!
    
    private static let sessionManager = SessionManager()
    
    convenience init(urlRequest: URLRequestConvertible) {
        self.init()
        self.urlRequest = urlRequest
    }
    
    /**
     Main handler of all the requests
     
     - Parameter url: a type conforming to `URLRequestConvertible`.
     - Parameter authenticate: boolean that identifies if the `URLRequest` needs an access token.
     - Parameter completion: a callback that contains and an optional `JSON` or an optional `NSError`, depending if the the requests succeeded or not.
     
     - Returns: an instance of the `URLRequest` created with the supplied parameters.
     */
    @discardableResult
    final func perform(_ success: @escaping SuccessBlock, failure: @escaping FailureBlock) -> URLRequest? {
        
        return RequestTask.sessionManager.request(urlRequest).responseJSON(completionHandler: { (response) in
            // Do something with the response, example, convert error messages to native Error type.
            
            if let error = response.error {
                failure(self.makeError(with: error.localizedDescription))
                return
            }
            
            if let response = response.result.value {
                success(response)
            } else {
                failure(self.makeError(with: "API error"))
            }
        }).request
    }
    
    private func makeError(with reason: String? = nil) -> NSError {
        let errorCode = 500
        let reason = reason ?? "Network Error"
        
        return NSError(domain: "Ngage",
                       code: errorCode,
                       userInfo: [NSLocalizedDescriptionKey: reason])
    }
    
}
