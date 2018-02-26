//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

protocol ContactsView {
    func setContactList(withContacts contacts: [Person])
    func showActivityIndicator()
    func hideActivityIndicator()
    func showAlert(withMessage message: String)
}

class ContactsTableViewController: UITableViewController, ContactsView {

    //MARK: - Properties
    
    var contactsList = [Person]()
    
    private var interactor: ContactsListInteractor!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        
        interactor = DefaultContactsListInteractor(withView: self)
        interactor.loadContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        title = Titles.CONTACTS_LIST_TITLE
        
        let cellFromNib = UINib(nibName: NibIdentifiers.CONTACTS_LIST_CELL, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: CellIdentifiers.CONTACT_CELL)
    }
    
    func setContactList(withContacts contacts: [Person]) {
        contactsList = contacts
        tableView.reloadData()
    }
    
    func showActivityIndicator() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideActivityIndicator() {
        HUD.hide()
    }
    
    func showAlert(withMessage message: String) {
        AlertManager.sharedAlert.displayStandardAlert(withViewController: self, title: Titles.APP_NAME,
                                                      andMessage: message)
    }

    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CONTACT_CELL, for: indexPath) as! ContactsTableViewCell
        
        let person = contactsList[indexPath.row]
        cell.setPerson(person)

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = contactsList[indexPath.row]
        let contactDetailsVC = ContactDetailsTableViewController(nibName: NibIdentifiers.CONTACT_DETAILS_TABLEVIEW, bundle: nil)
        contactDetailsVC.person = person
        
        self.navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Heights.CONTACT_CELL
    }
}
