//
//  ContactDetailTableViewCell.swift
//  Contacts
//
//  Created by Mary Marielle Miranda on 21/02/2018.
//  Copyright © 2018 Cybilltek. All rights reserved.
//

import UIKit




class ContactDetailTableViewCell: UITableViewCell {
  
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setInfo(withTitle title: String, andDetail detail: String) {
        self.title.text = title
        self.detail.text = detail
    }

}
