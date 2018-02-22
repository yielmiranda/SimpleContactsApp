//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    //MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    //MARK: - Methods
    
    func setInfo(withTitle title: String, andDetail detail: String) {
        lblTitle.text = title
        lblDetail.text = detail
    }

}
