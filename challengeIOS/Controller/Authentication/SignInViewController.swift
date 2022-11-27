//
//  SignInViewController.swift
//  challengeIOS
//
//  Created by sami on 26/11/2022.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

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
 
    @IBAction func btnLoginTapped(_ sender: Any) {
        if self.checkInputs(){
            self.login(email: self.emailTF.text!, password: self.passwordTF.text!)
        }else{
            print("------- check all inputs ... ")
        }
    }
    
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
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
        if self.emailTF.text!.isEmpty {
            isValid = false
        }
        
        if self.passwordTF.text!.isEmpty {
            isValid = false
        }
        
        return isValid
        
    }
    
    private func login(email:String, password:String){
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]  result, error in
            
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else{
                //error login .. ask to create account!
                print("------ error; ")
                print(error)
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            strongSelf.emailTF.resignFirstResponder()
            strongSelf.passwordTF.resignFirstResponder()
            strongSelf.performSegue(withIdentifier: "navigateToHome", sender: nil)
            
        })
        
    }
    
    private func showCreateAccount(email:String, password:String){
        let alert = UIAlertController(title: "Creer un compte!", message: "Voulez-vous creer un compte avec ces parametres?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuer", style: .default, handler: {_ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                
                guard let strongSelf = self else{
                    return
                }
                
                guard error == nil else{
                    //error login .. ask to create account!
                    print("------ Account creation failed ! error; ")
                    print(error)
                    
                    return
                }
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
