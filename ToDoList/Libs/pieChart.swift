//
//  pieChart.swift
//  ToDoList
//
//  Created by fu on 2020/8/5.
//  Copyright © 2020 fu. All rights reserved.
//

import UIKit

class pieChart: NSObject {
    
    let pi = CGFloat.pi/180
    // 圓心
    var centerX: Int = 50
    var centerY: Int = 50

    // 線寬
    var lineWidth: CGFloat = 10.0

    // 半徑
    var redius: CGFloat = 10

    // 百分比 (0 ~ 100)
    var percentage: Int = 0
    func setDataPercentage(percent: Int){
        self.percentage = percent
    }
    
    // 背景圖(灰色)的Layer
    var pieChartBackLayer: CALayer = CALayer()
    // 資料圖(藍色)的Layer
    var pieChartDataLayer: CALayer = CALayer()
    
    func pieChartInit(x: Int, y: Int, redius: CGFloat, lineWeight: CGFloat){
        // 避免半徑顯示超出去
        let newRedius = redius - lineWeight/2
            
        self.centerX = x
        self.centerY = y
        self.redius = newRedius
        self.lineWidth = lineWeight
    }
    
    func setPieChart(){
        let pieBackPath = UIBezierPath()
        pieBackPath.addArc(withCenter: CGPoint(x: self.centerX, y: self.centerY), radius: self.redius, startAngle: pi*270, endAngle: (270 + 360 * 50 / 100), clockwise: true)
        let pieBackLayer = CAShapeLayer()
        pieBackLayer.path = pieBackPath.cgPath
        pieBackLayer.strokeColor = UIColor.gray.cgColor
        pieBackLayer.lineWidth = self.lineWidth
        pieBackLayer.fillColor = UIColor.clear.cgColor
        self.pieChartBackLayer = pieBackLayer
    }
    
    func setPieChartData(){
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: self.centerX, y: self.centerY), radius: self.redius, startAngle: pi * 270, endAngle: pi * (270 + 360 * CGFloat(self.percentage) / 100), clockwise: true)
    
        let percentageLayer = CAShapeLayer()
        percentageLayer.path = percentagePath.cgPath
        percentageLayer.strokeColor  = UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor
        percentageLayer.lineWidth = self.lineWidth + 0.3
        // 圓弧
        percentageLayer.lineCap = .round
        // 把close的部分 不填顏色
        percentageLayer.fillColor = UIColor.clear.cgColor
        
        self.pieChartDataLayer = percentageLayer
    }
    
    func addLayer(view: UIView){
        view.layer.addSublayer(self.pieChartBackLayer)
        view.layer.addSublayer(self.pieChartDataLayer)
    }
    
}
