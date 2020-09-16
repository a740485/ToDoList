//
//  toDoTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/7/1.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class toDoTableViewCell: UITableViewCell {

    
    @IBOutlet var chartView: UIView!
    @IBOutlet var titleLab: UILabel!
    @IBOutlet var percentLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
