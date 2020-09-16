//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by fu on 2020/6/27.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userData = UserData.shared
    
    @IBOutlet var getData: UIButton!
    
    var projectOrder = UserData.shared.projectOrder{
        didSet{
            self.TodoTableView.reloadData()
        }
    }
    
    @IBOutlet var TodoTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getData.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.TodoTableView.dataSource = self
        self.TodoTableView.delegate = self
        self.TodoTableView.rowHeight = 100
        
        self.TodoTableView.register(UINib(nibName: "toDoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "toDoTableViewCell")
        
        // 下拉重整
        self.TodoTableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(reloadUserData), for: UIControl.Event.valueChanged)
        
        
    }
    // 下拉重整
    @objc func reloadUserData(){
        print("reloadUserData")
        self.TodoTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func seeProjectData(_ sender: UIButton) {
        print(" ====================== ")
        
        let getProjectData = self.userData.getProjectData()
        print("see projectData: \(getProjectData)")
        
        
        let getProjectOrder = self.userData.getProjectOrder()
        print("see project_Order: \(getProjectOrder)")
        
        
        let getCompleteOrder = self.userData.getCompleteOrder()
        print("see getCompleteOrder: \(getCompleteOrder)")
        
        let getCompleteData = self.userData.getCompleteData()
        print("see getCompleteData: \(getCompleteData)")
        
        print(" ====================== ")

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.projectOrder = UserData.shared.projectOrder
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let projectData: [String : Any ] = self.userData.getProjectData()
            return projectData.count
            
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = self.TodoTableView.dequeueReusableCell(withIdentifier: "toDoTableViewCell", for: indexPath) as! toDoTableViewCell
            
            let projectName = self.userData.getProjectOrder()
            
            cell.titleLab.text = projectName[indexPath.row]

            cell.chartView.backgroundColor = .clear
            let chartview:UIView = cell.chartView
            
            let projectData = self.userData.getProjectData()

             let data = projectData[projectName[indexPath.row]] as! [[Any]]
            let totle: Int = data.count 
             var okTotle: Int = 0
            
             for i in 0..<data.count {
                 if ((data[i][1] as? Int == 1) || (data[i][0] as? String == "1") || data[i][1] as! Bool == true) {
                     okTotle = okTotle + 1
                 }
             }
            
            var percent: Int
            if(totle == 0){
                percent = 0
            }else{
                percent = Int((Float(okTotle) / Float(totle)) * 100)
            }

            
            cell.percentLab.text = "\(okTotle) / \(totle)"
            self.addChart(view: chartview, percent: percent)
                
                 
                
            
            
            
            
            
            
            return cell
        default:
            print("default")
            return UITableViewCell()
        }
    }
    
    func addChart(view: UIView, percent: Int){
        let pieview = pieChart()
        let x: Int = Int(view.bounds.midX)
        let y: Int = Int(view.bounds.midY)
        let redius: CGFloat = view.bounds.height/2
        pieview.pieChartInit(x: x, y: y, redius: redius, lineWeight: 10)
        pieview.setDataPercentage(percent: percent)
        pieview.setPieChart()
        pieview.setPieChartData()
        pieview.addLayer(view: view)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            
            let projectOrder = self.userData.getProjectOrder()
            let name = projectOrder[indexPath.row]

            self.navigationController?.pushViewController(setToDoListViewController(name: name), animated: true)
            
        default:
            return
        }
    }
    
    // 左滑功能
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 0:
            
            let delete = UIContextualAction(style: .destructive, title: "刪除") { (UIContextualAction, UIView, completeHandelr) in

                self.alertDelete(row: indexPath.row)
//                self.userData.projectDataDelete(No: indexPath.row)
//                self.TodoTableView.reloadData()
            }
            
            let edit = UIContextualAction(style: .normal, title: "編輯") { (UIContextualAction, UIView, nil) in

                self.editProjectNameAlert(row: indexPath.row)
            }
            
            return UISwipeActionsConfiguration(actions: [delete,edit])
            
        default:
            return UISwipeActionsConfiguration()
        }
        
    }
    
    func alertDelete(row: Int){
        let alert = UIAlertController(title: "確認要刪除？", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            print("刪除")
            self.userData.projectDataDelete(No: row)
            
            self.TodoTableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 右滑功能
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 0:
            
            
            let complete = UIContextualAction(style: .normal, title: "完成") { (UIContextualAction, UIView, nil) in

                let name = self.userData.getProjectOrder()[indexPath.row]

                if let data = self.userData.getProjectData()[name]{
                    self.userData.projectDataDelete(No: indexPath.row)
                    self.userData.completeDataInsert(name: name, data: data)
                    self.TodoTableView.reloadData()
                }

                
            }
            
            complete.backgroundColor = UIColor(red: 34/255, green: 195/255, blue: 26/255, alpha: 1)
            
            return UISwipeActionsConfiguration(actions: [complete])
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
    
    func editProjectNameAlert(row:Int){
        let alert = UIAlertController(title: "更新專案名稱", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (contentName) in
            contentName.placeholder = "請輸入名稱"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if let name = alert.textFields?[0].text?.trimmingCharacters(in: .whitespaces){
                
                if(!name.isEmpty){
                    self.userData.projectDataEdit(No: row, name: name)
                    self.TodoTableView.reloadData()
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func AddToDoList(_ sender: UIButton) {
        self.navigationController?.pushViewController(setToDoListViewController(name: "new"), animated: true)
    }
  

    
    
    


}
