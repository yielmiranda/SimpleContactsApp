//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

class ContactsTableViewController: UITableViewController {

    //MARK: - Properties
    
    private var viewModel = ContactsListViewModel()
    
    private var contactsListObserver: NSObjectProtocol!
    private var isLoadingObserver: NSObjectProtocol!
    private var errorMessageObserver: NSObjectProtocol!
    
    //MARK: - View Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(contactsListObserver)
        NotificationCenter.default.removeObserver(isLoadingObserver)
        NotificationCenter.default.removeObserver(errorMessageObserver)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        
        viewModel.loadContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods
    
    private func setupObservers() {
        self.contactsListObserver = NotificationCenter.default.addObserver(forName: ContactsListViewModel.contactsListDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
        self.isLoadingObserver = NotificationCenter.default.addObserver(forName: ContactsListViewModel.isLoadingDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            let visibility = note.userInfo?[\ContactsListViewModel.isLoading] as? Bool ?? false
            self?.setActivityIndicator(withVisibility: visibility)
        })
        
        self.errorMessageObserver = NotificationCenter.default.addObserver(forName: ContactsListViewModel.errorMessageDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            let message = note.userInfo?[\ContactsListViewModel.errorMessage] as? String ?? ""
            self?.showAlert(withMessage: message)
        })
    }
    
    private func setupInterface() {
        title = Titles.CONTACTS_LIST_TITLE
        
        let cellFromNib = UINib(nibName: NibIdentifiers.CONTACTS_LIST_CELL, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: CellIdentifiers.CONTACT_CELL)
    }
    
    private func setActivityIndicator(withVisibility visibility: Bool) {
        if visibility {
            HUD.show(.progress, onView: self.view)
        } else {
            HUD.hide()
        }
    }
    
    private func showAlert(withMessage message: String) {
        AlertManager.sharedAlert.displayStandardAlert(withViewController: self, title: Titles.APP_NAME,
                                                      andMessage: message)
    }

    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.contactsList != nil else { return 0 }
        
        return viewModel.contactsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CONTACT_CELL, for: indexPath) as! ContactsTableViewCell
        
        let person = viewModel.contactsList[indexPath.row]
        cell.setPerson(person)

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = viewModel.contactsList[indexPath.row]
        let contactDetailsVC = ContactDetailsTableViewController(nibName: NibIdentifiers.CONTACT_DETAILS_TABLEVIEW, bundle: nil)
        contactDetailsVC.personId = person.id
        
        self.navigationController?.pushViewController(contactDetailsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Heights.CONTACT_CELL
    }
}
