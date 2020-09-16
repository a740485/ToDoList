//
//  ViewController.swift
//  ToDoList
//
//  Created by fu on 2020/6/27.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var tabBarView: UIView!
    var slideView: UIView!
    @IBOutlet var toDoBrnView: UIView!
    @IBOutlet var completeBtnView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switchpage(id: "ToDoView")
//        self.btnColorSwitch(id: "ToDoView")
        self.addSlideView()
        
        self.addGestureRecognizer()
    }
    
    // 所有手勢
    func addGestureRecognizer(){
        // 長按
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(MainViewController.longPress)
        )
        self.MainView.addGestureRecognizer(longPress)
        
        // 向左滑動
        let swipeLeft = UISwipeGestureRecognizer(
          target:self,
          action:#selector(MainViewController.swipe))
        swipeLeft.direction = .left
        // 為視圖加入監聽手勢
        self.MainView.addGestureRecognizer(swipeLeft)
        
        // 向右滑動
        let swipeRight = UISwipeGestureRecognizer(
          target:self,
          action:#selector(MainViewController.swipe))
        swipeRight.direction = .right
        // 為視圖加入監聽手勢
        self.MainView.addGestureRecognizer(swipeRight)
    }
    
    // 觸發長按手勢後 執行的動作
    @objc func longPress(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            print("長按開始")
        } else if recognizer.state == .ended {
            print("長按結束")
        }
    }
    
    @objc func swipe(recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .left:
            print("swipe left")
            let xCenter = (self.view.frame.width / 4) * 3
            self.slideViewAnimate(x: Double(xCenter))
            self.switchpage(id: "CompleteView")
            self.btnColorSwitch(id: "CompleteView")
            
        case .right:
            print("swipe right")
            let xCenter = (self.view.frame.width / 4)
            self.slideViewAnimate(x: Double(xCenter))
            self.switchpage(id: "ToDoView")
            self.btnColorSwitch(id: "ToDoView")
            
        default:
            break;
        }
    }
    
    
    var currentRootViewController: UIViewController?
    func switchpage(id: String){
        
        var viewController: UIViewController?
        
        switch id{
        case "ToDoView":
            viewController = UINavigationController(rootViewController: ToDoViewController())
            
            
        case "CompleteView":
            viewController = UINavigationController(rootViewController: CompleteViewController())
        default:
            break
        }
        
        // 給viewControllerID
        viewController?.restorationIdentifier = id
        
        //  讓id不同時才執行
        if let controller = viewController, controller.restorationIdentifier != self.currentRootViewController?.restorationIdentifier{
            self.addChild(controller)
            
            self.addViewControllerToContainer(viewController: controller, container: self.MainView)
            self.currentRootViewController?.view.removeFromSuperview()
            // 刪除parent
            self.currentRootViewController?.removeFromParent()
            
            self.currentRootViewController = controller
        }
    }
    
    func addViewControllerToContainer(viewController: UIViewController, container: UIView){
        container.backgroundColor = .clear
        
        if let newView = viewController.view{
            container.addSubview(newView)
            
            // 把自動設定關掉
            newView.translatesAutoresizingMaskIntoConstraints = false
            
            container.addConstraints([
                NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: newView, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1, constant: 0)
            ])
        }
    }
    
    func addSlideView(){
        print("frame: \(self.tabBarView.frame)")
        // (0.0, 0.0, 414.0, 94.0)
        let width = (self.view.frame.width / 2) - 20
        print("width = \(width)")
        self.slideView = UIView(frame: CGRect(x: 10, y: 2, width: width, height: 4))
        self.slideView.backgroundColor = .blue
        
        self.tabBarView.addSubview(slideView)
    }
    
    // 控制slideView中心
    func slideViewAnimate(x: Double){
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            self.slideView.center = CGPoint(x: x, y: 4)
        }
        animator.startAnimation()
    }
    
    func btnColorSwitch(id: String){
        
        let initColor: UIColor = UIColor(red: 255 / 255, green: 215 / 255, blue: 0, alpha: 1)
        self.toDoBrnView.backgroundColor = initColor
        self.completeBtnView.backgroundColor = initColor
        
        switch id {
        case "ToDoView":
            print("ToDoView")
            self.toDoBrnView.backgroundColor = UIColor(red: 238 / 255, green: 201 / 255, blue: 0, alpha: 1)
        case "CompleteView":
            print("CompleteView")
            self.completeBtnView.backgroundColor = UIColor(red: 238 / 255, green: 201 / 255, blue: 0, alpha: 1)
        default:
            break
        }
    }

    @IBAction func toDoBtn(_ sender: UIButton) {
        let xCenter = (self.view.frame.width / 4)
        self.slideViewAnimate(x: Double(xCenter))
        self.switchpage(id: "ToDoView")
        self.btnColorSwitch(id: "ToDoView")
    }
    
    @IBAction func completeBtn(_ sender: UIButton) {
        let xCenter = (self.view.frame.width / 4) * 3
        self.slideViewAnimate(x: Double(xCenter))
        self.switchpage(id: "CompleteView")
        self.btnColorSwitch(id: "CompleteView")
    }
    
    
}

