//
//  PostTableViewCell.swift
//  EngineerAITest
//
//  Created by Kushal Mandala on 20/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postSwitch: UISwitch!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
