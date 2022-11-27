//
//  SplashScreenViewController.swift
//  challengeIOS
//
//  Created by sami on 26/11/2022.
//

import UIKit
import Lottie
import FirebaseAuth

class SplashScreenViewController: UIViewController {
    
    @IBOutlet var loadingView: UIView!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        let isConnected:Bool = FirebaseAuth.Auth.auth().currentUser != nil
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5){
            if isConnected {
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }else{
                self.performSegue(withIdentifier: "navigateToSignIn", sender: nil)
            }
        }
    }
    
    
    private func setupAnimation(){
        animationView.animation = Animation.named("splash")
        animationView.frame = self.loadingView.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        loadingView.addSubview(animationView)
    }
}
