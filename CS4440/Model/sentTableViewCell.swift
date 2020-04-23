//
//  sentTableViewCell.swift
//  CS4440
//
//  Created by yassine attia on 4/23/20.
//  Copyright © 2020 Georgia Teach. All rights reserved.
//

import UIKit

class sentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sentiment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
