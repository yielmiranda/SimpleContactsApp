//
//  ContactDetailsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

protocol ContactsDetailView {
    func setContactDetails(withPerson person: Person)
    func setupContactDetailsList(withLabels labels: [String])
    func showLoading()
    func hideLoading()
    func showAlert(withMessage message: String)
}

class ContactDetailsTableViewController: UITableViewController, ContactsDetailView {
    
    //MARK: - Properties
  
    var person: Person!
  
    private var interactor: ContactsDetailsInteractor!
    
    private var cellTitles: [String] {
        get {
            return [Titles.NAME,
                    Titles.ADDRESS,
                    Titles.BIRTHDAY,
                    Titles.MOBILE_NUMBER,
                    Titles.EMAIL_ADDRESS,
                    Titles.CONTACT_PERSON,
                    Titles.CONTACT_PERSON_NUMBER]
        }
    }
    
    private var cellSubtitles: [String]!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
      
        interactor = DefaultContactDetailsInteractor(view: self)
        interactor.loadPerson(withId: person.id)
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        title = Titles.CONTACT_DETAILS_TITLE
        
        let cellFromNib = UINib(nibName: NibIdentifiers.CONTACT_DETAILS_CELL, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: CellIdentifiers.DETAIL_CELL)
    }
  
    func setContactDetails(withPerson person: Person) {
        self.person = person
    }
    
    func setupContactDetailsList(withLabels labels: [String]) {
        cellSubtitles = labels
        
        tableView.reloadData()
    }
  
    func showLoading() {
        HUD.show(.progress, onView: self.view)
    }
  
    func hideLoading() {
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
        return cellTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DETAIL_CELL,
                                                 for: indexPath) as! ContactDetailTableViewCell
        cell.setInfo(withTitle: cellTitles[indexPath.row], andDetail: cellSubtitles[indexPath.row])

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Heights.CONTACT_CELL
    }
}
