//
//  SignUpViewController.swift
//  challengeIOS
//
//  Created by Mohamed on 27/11/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    @IBOutlet var viewEmail: CustomView!
    @IBOutlet var viewPassword: CustomView!
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var imgEyePassword: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden = true
        self.passwordTF.isSecureTextEntry = true
    }
 
    @IBAction func btnRegisterTapped(_ sender: Any) {
        if self.checkInputs(){
            self.Register(email: self.emailTF.text!, password: self.passwordTF.text!)
        }else{
            print("------- check all inputs ... ")
            self.presentAlert(withTitle: "Erreur!", message: "Merci de verifier tout les champs")
        }
    }
    
    
    @IBAction func displayPassword(_ sender: Any) {
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
    
        if !self.passwordTF.isSecureTextEntry{
            self.imgEyePassword.image = UIImage(systemName: "eye.slash")
            self.imgEyePassword.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }else{
            self.imgEyePassword.image = UIImage(systemName: "eye")
            self.imgEyePassword.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    private func checkInputs()-> Bool{
        var isValid = true
        if self.emailTF.text!.isEmpty || !self.isValidEmail(self.emailTF.text!) {
            isValid = false
        }
        
        if self.passwordTF.text!.isEmpty {
            isValid = false
        }
        
        return isValid
        
    }
    
    private func Register(email:String, password:String){
        
        BokehLoader.show()
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
            
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else{
                BokehLoader.hide()
                return
            }
            BokehLoader.hide()
            
            strongSelf.showAlertWith(msg: "Vous pouvez maintenant accéder à la liste de marques. ")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3){
                strongSelf.performSegue(withIdentifier: "proceedToHome", sender: nil)
            }
        })
        
    }
    

}
