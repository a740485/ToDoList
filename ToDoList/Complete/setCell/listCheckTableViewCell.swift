//
//  listCheckTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/7/17.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class listCheckTableViewCell: UITableViewCell {

    
    @IBOutlet var contentNameLab: UILabel!
    @IBOutlet var checkImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
