//
//  UIViewExtension.swift
//  challengeIOS
//
//  Created by Mohamed on 26/11/2022.
//

import Foundation
import SwiftUI
import UIKit

@IBDesignable
class CustomView: UIView {
    
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
    
    func isSelected(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemYellow.cgColor
    }
    
    func isValid(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    func isInvalid(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemRed.cgColor
    }
}
