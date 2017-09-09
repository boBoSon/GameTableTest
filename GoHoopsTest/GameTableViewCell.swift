//
//  GameTableViewCell.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/9/1.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var guestLbl: UILabel!
    @IBOutlet weak var homeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
