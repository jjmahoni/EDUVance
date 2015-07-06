//
//  ListCell.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var hwi_titleLabel: UILabel!
    @IBOutlet weak var hwi_newImageView: UIImageView!
    @IBOutlet weak var hwi_dateLabel: UILabel!
    @IBOutlet weak var hwi_contentLabel: UILabel!
    @IBOutlet weak var hwi_wrdateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
