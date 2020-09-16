//
//  listContentTableViewCell.swift
//  ToDoList
//
//  Created by fu on 2020/6/29.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class listContentTableViewCell: UITableViewCell {

    
    @IBOutlet var checkBtn: UIButton!
    @IBOutlet var contentLab: UILabel!
    
    var userData = UserData.shared
    var listItems: [[Any]] = UserData.shared.newlistItem ?? [[]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkBtn.setBackgroundImage(UIImage(systemName: "stop"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func checkBtn(_ sender: UIButton) {
        
        // stop : 未打勾
        // checkmark.square : 打勾
        
        let checkBtnImage = self.checkBtn.currentBackgroundImage
        
        switch checkBtnImage {
        case UIImage(systemName: "stop"):
            self.checkBtn.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            print("打勾")
            self.userData.newListBtnEdit(No: sender.tag, type: true)
            
        case UIImage(systemName: "checkmark.square"):
            self.checkBtn.setBackgroundImage(UIImage(systemName: "stop"), for: .normal)
            print("不打勾")
            self.userData.newListBtnEdit(No: sender.tag, type: false)

        default:
            self.checkBtn.setBackgroundImage(UIImage(systemName: "stop"), for: .normal)
        }
        
    }
    
    
}
