//
//  setToDoListViewController.swift
//  ToDoList
//
//  Created by fu on 2020/6/27.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit




class setToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, setToDoListProtocal {
    
    var listName: String = "new"
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(name: String){
        self.init()
        self.listName = name
        
        let listData = self.userData.getListItem(projectName: name)
        self.userData.newlistItem = listData as? [[Any]]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    var listNameTableView: listNameTableViewCell?
    
    var userData = UserData.shared
    
    var newlistItems: [[Any]] = UserData.shared.newlistItem ?? [[]]{
        didSet{
            self.setTableView.reloadData()
        }
    }
    

    @IBOutlet var navBarLab: UILabel!
    
    @IBOutlet var setTableView: UITableView!
    
    let addNewContentTableCell = addNewContentTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView.dataSource = self
        self.setTableView.delegate = self
        self.setTableView.allowsSelection = false
        self.navBarLab.text = self.listName
        
        self.setTableView.register(UINib(nibName: "listNameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "listNameTableViewCell")
        self.setTableView.register(UINib(nibName: "listContentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "listContentTableViewCell")
        self.setTableView.register(UINib(nibName: "addNewContentTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "addNewContentTableViewCell")
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if(self.listName == "new"){
                return 1
            }else{
                // 不是新增專案 所以屏蔽掉輸入名稱
                return 0
            }
            
        case 1:
            if let listItmes = self.userData.newlistItem{
                if(listItmes.isEmpty){
                   return 0
                }else{
                    return listItmes.count
                }
            }
            
            
            
            return self.userData.newlistItem?.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return 60
        case 2:
            return 50
        default:
            return 0 
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = self.setTableView.dequeueReusableCell(withIdentifier: "listNameTableViewCell", for: indexPath) as! listNameTableViewCell
            
            self.listNameTableView = cell
            
            return cell
        case 1:
            let cell = self.setTableView.dequeueReusableCell(withIdentifier: "listContentTableViewCell", for: indexPath) as! listContentTableViewCell
            
            if let newListItem = UserData.shared.newlistItem{
                
                
                if(newListItem[indexPath.row].isEmpty){
                    return UITableViewCell()
                }else{

                    let listItem:Array = newListItem[indexPath.row]
                    
                    cell.contentLab.text = listItem[0] as? String

                    if(listItem[1] as!Bool){
                       cell.checkBtn.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                    }else{
                        cell.checkBtn.setBackgroundImage(UIImage(systemName: "stop"), for: .normal)
                    }
                    
                }

            }
            
            cell.checkBtn.tag = indexPath.row
            
            return cell
            
        case 2:
            let cell = self.setTableView.dequeueReusableCell(withIdentifier: "addNewContentTableViewCell", for: indexPath) as! addNewContentTableViewCell
            cell.delegate = self
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 0:
            return UISwipeActionsConfiguration()
        case 1:
            
            let delete = UIContextualAction(style: .destructive, title: "刪除") { (UIContextualAction, UIView, completeHandelr) in

                self.userData.newListDeleteItem(No: indexPath.row)
                self.setTableView.reloadData()
            }
            
            let edit = UIContextualAction(style: .normal, title: "編輯") { (UIContextualAction, UIView, nil) in
                
                self.editContentAlert(row: indexPath.row)
            }
            
            return UISwipeActionsConfiguration(actions: [delete,edit])
            
            
            
        case 2:
            return UISwipeActionsConfiguration()
        default:
            return UISwipeActionsConfiguration()
        }
        
    }
    
    
    
    @IBAction func goBackBtn(_ sender: UIButton) {
        self.userData.newlistItem = []
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getprojectName(){
        
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        var projectName: String = ""
        if(self.listName == "new"){
            if let name = self.listNameTableView?.projectNameTextField.text, !name.isEmpty{
                // 有專案名稱
                projectName = name
                
                let newListItems = self.userData.getNewListItems()
                
                let projectOrder = self.userData.getProjectOrder()
                if(projectOrder.contains(name)){
                    print("have this name")
                    self.projectNameExistAlert(projectName: projectName, newListItems: newListItems)
                }else{
                    
                    self.userData.projectDataInsert(name: projectName, data: newListItems)
                    self.userData.projectOrderInsert(name: projectName)
                    self.userData.newlistItem = []
                    self.navigationController?.popViewController(animated: true)
                }

            }else{
                // 提醒填寫專案名稱
                self.projectNameAlert()
            }
        }else{
            projectName = self.listName
            
            let newListItems = self.userData.getNewListItems()

            self.userData.projectDataInsert(name: projectName, data: newListItems)
            
            self.userData.newlistItem = []
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func projectNameAlert(){
        let alert = UIAlertController(title: "專案名稱未填寫", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func projectNameExistAlert(projectName: String, newListItems: Any){

        let projectNameExistalert = UIAlertController(title: "專案名稱重複", message: "是否要覆蓋之前的專案呢", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            // 確定覆蓋更新
            self.userData.projectDataInsert(name: projectName, data: newListItems)
            self.userData.projectOrderInsert(name: projectName)

            self.userData.newlistItem = []
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        projectNameExistalert.addAction(okAction)
        projectNameExistalert.addAction(cancelAction)
        present(projectNameExistalert, animated: true, completion: nil)
    }
    
    func editContentAlert(row:Int){
        let alert = UIAlertController(title: "更新代辦事項", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (contentName) in
            contentName.placeholder = "請輸入名稱"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if let name = alert.textFields?[0].text{

                self.userData.newListNameEdit(No: row, name: name)
                self.setTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func addContemtAlert(){
        
        
        let alert = UIAlertController(title: "新增待辦事項", message: nil, preferredStyle: .alert)
        alert.addTextField { (contentName) in
            contentName.placeholder = "請輸入名稱"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let name = alert.textFields?[0].text{
                
                self.userData.newListAddItem(name: name)
                self.setTableView.reloadData()
                
                
                // tableview即時新增一行 [
//                self.setTableView.insertRows(at: [IndexPath(row: self.listItems.count - 1, section: 1)], with: .automatic)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.userData.newlistItem = []
    }
    
}
