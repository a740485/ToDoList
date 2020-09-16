//
//  listNameTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/6/29.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit


class listNameTableViewCell: UITableViewCell, UITextFieldDelegate {
    


    @IBOutlet var projectNameTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.projectNameTextField.delegate = self

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.projectNameTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
    }
    
}
