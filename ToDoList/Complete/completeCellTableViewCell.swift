//
//  completeCellTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/8/5.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class completeCellTableViewCell: UITableViewCell {

    
    @IBOutlet var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
