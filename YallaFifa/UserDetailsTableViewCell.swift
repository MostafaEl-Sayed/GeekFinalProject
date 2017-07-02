//
//  UserDetailsTableViewCell.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/16/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(newPS: User) {
        userName.text = newPS.email
        userPhone.text = newPS.phone        
    }


}
