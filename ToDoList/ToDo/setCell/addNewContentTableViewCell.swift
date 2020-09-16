//
//  addNewContentTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/6/30.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

protocol setToDoListProtocal {
    func addContemtAlert()
}

class addNewContentTableViewCell: UITableViewCell {

    var delegate: setToDoListProtocal?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addNewContent(_ sender: UIButton) {
        self.delegate?.addContemtAlert()
    }
    
    
    
    
    
    
}
