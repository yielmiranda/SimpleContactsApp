//
//  ContactDetailInteractor.swift
//  Contacts
//
//  Created by sprixes on 22/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
@objc protocol ContactsDetailInteractor {
  @objc optional func loadPersonById(id:String)
  
}
class DefaultContactDetailInteractor: ContactsDetailInteractor {
  var view : ContactsDetailView!
  var manager: ContactsManager!
  
  init(view : ContactsDetailView) {
    self.view = view
    self.manager = ContactsManager() //This should be on the Constructor
    //Manager should have a protocol
  }
  
  func loadPersonById(id:String){
    view.showLoading?()
    //Load Contact Manager by Id
    view.refreshView?()
    onLoadPersonSuccess()
    
  }
  
  private func onLoadPersonSuccess() {
    view.hideLoading?()
  }
  
  private func onLoadPersonFail() {
    view.hideLoading?()
    view.showAlert?(withMessage: "Load Person Fail")
  }
  
}
