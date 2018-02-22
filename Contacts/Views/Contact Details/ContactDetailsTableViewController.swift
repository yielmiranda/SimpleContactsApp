//
//  ContactDetailsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class ContactDetailsTableViewController: UITableViewController {

    //MARK: - Properties
    
    var person = Person()
    
    private let titleLabels = [titles.name,
                               titles.address,
                               titles.birthday,
                               titles.mobileNumber,
                               titles.emailAddress,
                               titles.contactPerson,
                               titles.contactPersonNumber]
    
    var details = [String]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        displayContactDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        title = titles.contactsDetailsTitle
        
        let cellFromNib = UINib(nibName: nibIdentifiers.contactDetailsCell, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: cellIdentifiers.detailCell)
    }
    
    private func displayContactDetails() {
        details = [person.firstName + " " + person.lastName,
                   person.address,
                   person.birthday,
                   person.mobileNumber,
                   person.emailAddress,
                   person.contactPersonName,
                   person.contactPersonNumber]
        
        tableView.reloadData()
    }

    //MARK: - UITableView
    
    //MARK: Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.detailCell, for: indexPath) as! ContactDetailTableViewCell
        cell.setInfo(withTitle: titleLabels[indexPath.row], andDetail: details[indexPath.row])

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
