//
//  BokehLoader.swift
//  challengeIOS
//
//  Created by Mohamed on 27/11/2022.
//

import Foundation
import SwiftyGif
import NVActivityIndicatorView

struct BokehLoader {
    static func show() {
        LoadingOverlay.shared.showOverlay()
    }
    static func hide() {
        LoadingOverlay.shared.hideOverlayView()
    }
}

private class LoadingOverlay {
    
    var overlayView : UIView!
    var gifImageView:UIImageView!
    var containerView:UIView!
    
    var activityIndicator : NVActivityIndicatorView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init() {
        self.containerView = UIView(frame: UIScreen.main.bounds)
        self.containerView.backgroundColor = UIColor.clear
        
        self.overlayView = UIView()
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        overlayView.backgroundColor = .white
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.type = .ballClipRotate
        activityIndicator.color = UIColor.green
        
        overlayView.addSubview(activityIndicator)
        
        containerView.addSubview(overlayView)
    }
    
    public func showOverlay() {
        let view = UIApplication.shared.keyWindow
        overlayView.center = (view?.center)!
        view?.addSubview(containerView)
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}
