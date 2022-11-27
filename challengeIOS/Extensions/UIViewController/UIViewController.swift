//
//  UIViewController.swift
//  challengeIOS
//
//  Created by Mohamed on 27/11/2022.
//

import UIKit
import NVActivityIndicatorView
import SDWebImage


extension UIViewController{
    
    func navigateToController(controller: UIViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    func addGestatureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
    }
    
    public  func showAlertWith(msg:String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
   
    public func AlertInternetEchec(){
        self.showAlertWith(msg: "الرجاء التثبت من خدمة الانترنت")
    }
    
    func ClearCacheImages() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }

}

extension UIAlertController {
    
    
    private struct ActivityIndicatorData {
        static var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    
    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
        ActivityIndicatorData.activityIndicator.color = UIColor.systemTeal
        ActivityIndicatorData.activityIndicator.type = .ballBeat
        ActivityIndicatorData.activityIndicator.startAnimating()
        
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        
        
        self.setValue(vc, forKey: "contentViewController")
    }
    
    func dismissActivityIndicator() {
        ActivityIndicatorData.activityIndicator.stopAnimating()
        self.dismiss(animated: false)
    }
}


extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(message : String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}


extension UIView {
    
    func startRotating(duration: Double = 3) {
        
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: kAnimationKey)
        }
        
    }
    
    func stopRotating() {
        let kAnimationKey = "rotation"
        
        if self.layer.animation(forKey: kAnimationKey) != nil {
            self.layer.removeAnimation(forKey: kAnimationKey)
        }
    }
    
    public func addRadiusCornerWithRadius(radius:Float){
        self.layer.masksToBounds = true
        self.layer.cornerRadius =  CGFloat(radius)
    }
    
    public func addBorderWithColor(color:UIColor,radius:CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = radius
    }
    
    public func makeCircularFrame(){
        let maxSize = max(self.frame.size.width, self.frame.size.height)
        self.addRadiusCornerWithRadius(radius: Float(maxSize/2.0))
    }
    
    func dropShadow(opacite: Float) {
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        self.layer.shadowOpacity = opacite
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        
        
    }
    
    func dropShadowtotal(opacite: Float) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = opacite
        //  self.layer.shadowPath = shadowPath.cgPath
        
        self.layer.shadowRadius = 10.0
        self.layer.masksToBounds = false
    }
    
    func dropShadowtotal1(opacite: Float) {
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = opacite
        //  self.layer.shadowPath = shadowPath.cgPath
        
        self.layer.shadowRadius = 20.0
        self.layer.masksToBounds = false
    }
    
    func roundCorners1(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}




