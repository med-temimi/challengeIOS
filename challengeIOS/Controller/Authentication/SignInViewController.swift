//
//  SignInViewController.swift
//  challengeIOS
//
//  Created by Mohamed on 26/11/2022.
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
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
    }
 
    @IBAction func btnLoginTapped(_ sender: Any) {
        if self.checkInputs(){
            self.login(email: self.emailTF.text!, password: self.passwordTF.text!)
        }else{
            print("------- check all inputs ... ")
            self.presentAlert(withTitle: "Erreur!", message: "Vérifier vos informations d'identification.")
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
            self.viewEmail.isInvalid()
        }
        
        if self.passwordTF.text!.isEmpty {
            isValid = false
            self.viewPassword.isInvalid()
        }
        
        return isValid
        
    }
    
    private func login(email:String, password:String){
        
        BokehLoader.show()
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]  result, error in
            
            guard let strongSelf = self else{
                return
            }
            
            BokehLoader.hide()
            
            guard error == nil else{
                print("------ error; ")
                print(error)
                BokehLoader.hide()
                strongSelf.presentAlert(withTitle: "Erreur!", message: "Aucun profil avec ces identificateurs n'a été trouvé!")
                return
            }
            
            strongSelf.emailTF.resignFirstResponder()
            strongSelf.passwordTF.resignFirstResponder()
            strongSelf.performSegue(withIdentifier: "navigateToHome", sender: nil)
            
        })
        
    }

    
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.emailTF{
            viewEmail.isSelected()
        }
        if textField == self.passwordTF{
            viewPassword.isSelected()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTF{
            if textField.text == nil || textField.text == "" || !self.isValidEmail(textField.text!){
                viewEmail.isInvalid()
            }else{
                viewEmail.isValid()
            }
        }
        
        if textField == self.passwordTF{
            if textField.text == nil || textField.text == ""{
                viewPassword.isInvalid()
            }else{
                viewPassword.isValid()
            }
        }
    }
}
