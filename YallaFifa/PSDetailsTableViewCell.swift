//
//  PSDetailsTableViewCell.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class PSDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var psName: UILabel!
    @IBOutlet weak var psPhoneNumber: UILabel!
    @IBOutlet weak var psAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(newPS: User) {
        psName.text = newPS.email
        psPhoneNumber.text = newPS.phone        
    }

}
