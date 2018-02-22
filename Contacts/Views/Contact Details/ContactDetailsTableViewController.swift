//
//  ContactDetailsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

@objc protocol ContactsDetailView {
  @objc optional func setContactDetail(withContacts contacts: Person)
  @objc optional func refreshView()
  @objc optional func showLoading()
  @objc optional func hideLoading()
  @objc optional func showAlert(withMessage message: String)
}

class ContactDetailsTableViewController: UITableViewController, ContactsDetailView {


    let cellHeight: CGFloat = 74
  
    var id: String = "1"
  
    var person = Person()
  
    var interactor : ContactsDetailInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInteractor()
        setupHeaderTitle()
        registerContactDetailCell()
      
        interactor.loadPersonById!(id: self.id)

    }
  
    private func initializeInteractor() {
      interactor = DefaultContactDetailInteractor(view: self)
    }
  
    func refreshView() {
      tableView.reloadData()
    }
  
    private func registerContactDetailCell(){
      let cellFromNib = UINib(nibName: nibIdentifiers.contactDetailsCell, bundle: nil)
      tableView.register(cellFromNib, forCellReuseIdentifier: cellIdentifiers.detailCell)
    }
  
    private func setupHeaderTitle(){
      title = Titles.CONTACT_DETAIL_TITLE
    }
  
    func setContactDetail(withContacts contacts: Person){
      self.person = contacts
    }
  
    func showLoading(){
      HUD.show(.progress, onView: self.view)
    }
  
    func hideLoading(){
      HUD.hide()
    }
  
    func showAlert(withMessage message: String){
      AlertManager
        .sharedAlert
        .displayStandardAlert(withViewController: self,
                              title: Titles.appName,
                              andMessage: message)
    }
  
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.detailCell,
                                                 for: indexPath) as! ContactDetailTableViewCell
      
      
        cell.setInfo(withTitle: person.arrayTitle()[indexPath.row],
                     andDetail: person.array()[indexPath.row])

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //get this from resource config
        return cellHeight
    }
}
