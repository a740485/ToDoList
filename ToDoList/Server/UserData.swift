//
//  UserData.swift
//  ToDoList
//
//  Created by fu on 2020/7/1.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class UserData: NSObject {
    static let shared = UserData()
    
    let userDefault = UserDefaults()
    
    var projectOrder: [String]? = [] {
        didSet{
            self.userDefault.set(self.projectOrder, forKey: "projectOrder")
        }
    }
    var projectData: [String : Any ]? = [:]{
        didSet{
            self.userDefault.set(self.projectData, forKey: "projectData")
        }
    }
    
    var completeOrder: [String]? = [] {
        didSet{
            self.userDefault.set(self.completeOrder, forKey: "completeOrder")
        }
    }
    var completeData: [String : Any ]? = [:]{
        didSet{
            self.userDefault.set(self.completeData, forKey: "completeData")
        }
    }
    
    var newlistItem: [[Any]]? = []
    
    
    override init() {

        if let projectData = self.userDefault.value(forKey: "projectData"){
            print("data: \(projectData)")
            self.projectData = projectData as? [String : Any]
        }

        if let projectOrder = self.userDefault.value(forKey: "projectOrder"){
            print("order: \(projectOrder)")
            self.projectOrder = projectOrder as? [String]
        }
        
        if let completeData = self.userDefault.value(forKey: "completeData"){
            print("completeData: \(completeData)")
            self.completeData = completeData as? [String : Any]
        }
        
        if let completeOrder = self.userDefault.value(forKey: "completeOrder"){
            print("order: \(completeOrder)")
            self.completeOrder = completeOrder as? [String]
        }

    }
    
    func getNewListItems() -> Any{
        return self.newlistItem ?? []
    }
    
    func getProjectOrder() -> [String]{
        return self.projectOrder ?? []
    }
    
    func getProjectData() -> [String : Any ]{
        return self.projectData ?? [:]
    }
    
    func getCompleteOrder() -> [String]{
        return self.completeOrder ?? []
    }
    
    func getCompleteData() -> [String : Any ]{
        return self.completeData ?? [:]
    }
    
    
    
    func getListItem(projectName: String) -> Any{
        return self.projectData?[projectName] ?? []
    }
    
    // 新增
    func newListAddItem(name: String){
        let data:[Any] = [name, false]
        self.newlistItem?.append(data)
    }
    
    // 刪除
    func newListDeleteItem(No: Int){
        self.newlistItem!.remove(at: No)
    }
    
    // 打勾修改
    func newListBtnEdit(No: Int, type: Bool){
        self.newlistItem?[No][1] = type
    }
    
    // 名稱修改
    func newListNameEdit(No: Int, name: String){
        self.newlistItem?[No][0] = name
    }
    
    func projectOrderInsert(name: String){
        self.projectOrder?.append(name)
    }
    
    // projectData 新增
    func projectDataInsert(name:String, data: Any){
        self.projectData?[name] = data
    }
    
    // projectData 修改
    func projectDataEdit(No:Int, name: String){
        if let key = self.projectOrder?[No]{
            self.projectOrder?[No] = name
            let value = self.projectData?[key]
            
            self.projectData!.removeValue(forKey: key)
            self.projectData![name] = value!
        }
    }
        
    // projectData 刪除
    func projectDataDelete(No: Int){
        print("projectDataDelete")
        if let name = self.projectOrder?[No]{
            self.projectOrder?.remove(at: No)
            self.projectData?.removeValue(forKey: name)
        }
    }
    
    // completeData 新增
    func completeDataInsert(name:String, data: Any){
        self.completeData?[name] = data
        self.completeOrder?.insert(name, at: 0)
    }
    
    // completeData 刪除
    func completeDataDelete(No: Int){
        print("completeDataDelete")
        if let name = self.completeOrder?[No]{
            self.completeOrder?.remove(at: No)
            self.completeData?.removeValue(forKey: name)
        }
    }
    
}
