//
//  CompleteViewController.swift
//  ToDoList
//
//  Created by fu on 2020/6/27.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class CompleteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var userData = UserData.shared
    
    @IBOutlet var mainTableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.rowHeight = 100
        
        self.mainTableView.register(UINib(nibName: "noCompleteDataTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "noCompleteDataTableViewCell")
        
        self.mainTableView.register(UINib(nibName: "completeCellTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "completeCellTableViewCell")
        
        
        
        // 下拉重整
        self.mainTableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(reloadUserData), for: UIControl.Event.valueChanged)
    }
    
    // 下拉重整
    @objc func reloadUserData(){
        print("reloadUserData")
        self.mainTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            if(self.userData.getCompleteOrder().count == 0){
                return 1
            }else{
                return 0
            }
            
        case 1:
            return self.userData.getCompleteOrder().count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 100
        default:
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            let name = self.userData.getCompleteOrder()[indexPath.row]

            self.navigationController?.pushViewController(seeToDoListVC(name: name), animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "noCompleteDataTableViewCell", for: indexPath) as! noCompleteDataTableViewCell
            
            return cell
        case 1:
            let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "completeCellTableViewCell", for: indexPath) as! completeCellTableViewCell
                
            let completeOrder: Array = self.userData.getCompleteOrder()
            
            cell.titleLab.text = completeOrder[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    // 左滑功能
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 1:
            
            let delete = UIContextualAction(style: .destructive, title: "刪除") { (UIContextualAction, UIView, completeHandelr) in

                self.alertDelete(row: indexPath.row)
            }
            
            let edit = UIContextualAction(style: .normal, title: "返回代辦清單") { (UIContextualAction, UIView, nil) in

                let name = self.userData.getCompleteOrder()[indexPath.row]

                if let data = self.userData.getCompleteData()[name]{
                    self.userData.completeDataDelete(No: indexPath.row)
                    self.userData.projectDataInsert(name: name, data: data)
                    self.userData.projectOrderInsert(name: name)
                    self.mainTableView.reloadData()
                }
            }
            
            return UISwipeActionsConfiguration(actions: [edit, delete])
            
        default:
            return UISwipeActionsConfiguration()
        }
    }
    
    func alertDelete(row: Int){
        let alert = UIAlertController(title: "確認要刪除？", message: nil, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { (_) in
            print("刪除")
            self.userData.completeDataDelete(No: row)
            self.mainTableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        
        
        present(alert, animated: true, completion: nil)
    }

}
