//
//  seeToDoListVC.swift
//  ToDoList
//
//  Created by fu on 2020/7/17.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class seeToDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userData = UserData.shared

    var listName: String = ""
    
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet var titleLab: UILabel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String){
        self.init()
        self.listName = name
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.allowsSelection = false
        
        self.titleLab.text = self.listName
        
        self.mainTableView.register(UINib(nibName: "listCheckTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "listCheckTableViewCell")
        
    }
    

    
    @IBAction func goBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data:[Any] = self.userData.getCompleteData()[listName] as? [Any]{
            return data.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "listCheckTableViewCell", for: indexPath) as! listCheckTableViewCell
        
        if let userdata: [Any] = self.userData.getCompleteData()[self.listName] as? [Any]{
            
            let data:[Any] = userdata[indexPath.row] as! [Any]
            
            print("data: \(data)")
            
            
            cell.contentNameLab.text = data[0] as? String
            
            if(data[1]) as! Bool{
                cell.checkImg.image = UIImage(systemName: "checkmark.square")
            }else{
                cell.checkImg.image = UIImage(systemName: "stop")
            }
        }

        return cell
    }

}
