//
//  ContactTableViewCell.swift
//  ContactMe
//
//  Created by royli on 20/12/2019.
//  Copyright © 2019 IPL-Master. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var carieerLabel: UILabel!
    
    @IBOutlet weak var interestLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
