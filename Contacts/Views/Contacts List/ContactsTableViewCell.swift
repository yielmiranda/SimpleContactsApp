//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    //MARK: - View Life Cyclle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    
    func setPerson(_ person: Person) {
        lblName.text = person.firstName + " " + person.lastName
        lblMobileNumber.text = person.mobileNumber
    }
}
