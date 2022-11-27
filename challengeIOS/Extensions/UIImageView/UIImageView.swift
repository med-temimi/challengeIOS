//
//  UIImageView.swift
//  challengeIOS
//
//  Created by sami on 26/11/2022.
//

import Foundation
import SwiftUI
import UIKit

@IBDesignable
class CustomImageView: UIImageView {
    
    var shadowAdded: Bool = false
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        updateLayerProperties()
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 111/255, green: 10/255, blue: 114/255, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = true
        
        
    }
}


class CircleShape: UIImageView {
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView() -> () {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1 // your desired value
            
        let circlePath = UIBezierPath(
                arcCenter: CGPoint(x:halfSize,y:halfSize),
                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
                startAngle: CGFloat(0),
                endAngle:CGFloat(M_PI * 2),
                clockwise: true)
    
         let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        shapeLayer.fillColor = UIColor(red: 111/255, green: 10/255, blue: 114/255, alpha: 0.1).cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
         shapeLayer.lineWidth = desiredLineWidth
    
         layer.addSublayer(shapeLayer)
     }
}


