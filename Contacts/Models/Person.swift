//
//  Person.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class Person: NSObject {
    var id = 0
    var firstName = ""
    var lastName = ""
    var address = ""
    var birthday = ""
    var emailAddress = ""
    var mobileNumber = ""
    
    var contactPersonName = ""
    var contactPersonNumber = ""
  
    var length = 7
  
  func getCount() -> Int {
    return length
  }
  
    func array() -> [String] {
      var array = [String](repeating: "", count: length)
      
      array[0] = firstName + " " + lastName
      array[1] = address
      array[2] = birthday
      array[3] = mobileNumber
      array[4] = emailAddress
      array[5] = contactPersonName
      array[6] = contactPersonNumber
      return array
    }
  
    func arrayTitle() -> [String] {
     var array = [String](repeating: "", count: length)
      array[0] = Titles.NAME
      array[1] = Titles.ADDRESS
      array[2] = Titles.BIRTHDAY
      array[3] = Titles.MOBILENUMBER
      array[4] = Titles.EMAILADDRESS
      array[5] = Titles.CONTACTPERSON
      array[6] = Titles.CONTACTPERSONNUMBER
    return array
  }
  
  
}
