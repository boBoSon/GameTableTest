//
//  TeamInfoTableViewCell.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/9/9.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class TeamInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var jerseyNoLbl: UILabel!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var jerseyNoTf: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
