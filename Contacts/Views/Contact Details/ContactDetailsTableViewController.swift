//
//  ContactDetailsTableViewController.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit
import PKHUD

class ContactDetailsTableViewController: UITableViewController {
    
    //MARK: - Properties
  
    var personId: Int!
  
    private var viewModel = ContactsDetailsViewModel()
    
    private var cellTitles: [String] {
        get {
            return [Titles.NAME,
                    Titles.USERNAME,
                    Titles.ADDRESS,
                    Titles.MOBILE_NUMBER,
                    Titles.EMAIL_ADDRESS,
                    Titles.WEBSITE]
        }
    }
    
    private var personObjectObserver: NSObjectProtocol!
    private var personLabelsObserver: NSObjectProtocol!
    private var isLoadingObserver: NSObjectProtocol!
    private var errorMessageObserver: NSObjectProtocol!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
      
        viewModel.loadPerson(withId: personId)
    }
    
    //MARK: - Methods
    
    private func setupInterface() {
        title = Titles.CONTACT_DETAILS_TITLE
        
        let cellFromNib = UINib(nibName: NibIdentifiers.CONTACT_DETAILS_CELL, bundle: nil)
        tableView.register(cellFromNib, forCellReuseIdentifier: CellIdentifiers.DETAIL_CELL)
    }
    
    private func setupObservers() {
        self.personLabelsObserver = NotificationCenter.default.addObserver(forName: ContactsDetailsViewModel.personLabelsDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
        self.isLoadingObserver = NotificationCenter.default.addObserver(forName: ContactsDetailsViewModel.isLoadingDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            let visibility = note.userInfo?[\ContactsDetailsViewModel.isLoading] as? Bool ?? false
            self?.setActivityIndicator(withVisibility: visibility)
        })
        
        self.errorMessageObserver = NotificationCenter.default.addObserver(forName: ContactsDetailsViewModel.errorMessageDidChange, object: nil, queue: nil, using: { [weak self] (note) in
            let message = note.userInfo?[\ContactsDetailsViewModel.errorMessage] as? String ?? ""
            self?.showAlert(withMessage: message)
        })
    }
    
    private func setActivityIndicator(withVisibility visibility: Bool) {
        if visibility {
            HUD.show(.progress, onView: self.view)
        } else {
            HUD.hide()
        }
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
        guard viewModel.personLabels != nil else { return 0 }
        
        return viewModel.personLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.DETAIL_CELL,
                                                 for: indexPath) as! ContactDetailTableViewCell
        cell.setInfo(withTitle: cellTitles[indexPath.row], andDetail: viewModel.personLabels[indexPath.row])

        return cell
    }
    
    //MARK: Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Heights.CONTACT_CELL
    }
}
