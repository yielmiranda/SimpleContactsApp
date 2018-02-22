//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

class ContactsTableViewController: UITableViewController, ContactsView {

    //MARK: - Properties
    
    var contactsList = [Person]()
    
    private var interactor = ContactsInteractor()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.initContactsInteractor(withView: self)
        interactor.loadContacts()
        
        setupInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        title = titles.contactsListTitle
        
        let cellFromNib = UINib(nibName: nibIdentifiers.contactsListCell, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: cellIdentifiers.contactCell)
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
        AlertManager.sharedAlert.displayStandardAlert(withViewController: self, title: titles.appName, andMessage: message)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.contactCell, for: indexPath) as! ContactsTableViewCell
        let person = contactsList[indexPath.row]
        cell.setPerson(person)

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = contactsList[indexPath.row]
        let contactDetailsVC = ContactDetailsTableViewController(nibName: nibIdentifiers.contactDetailsTableView, bundle: nil)
        contactDetailsVC.person = person
        
        self.navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
