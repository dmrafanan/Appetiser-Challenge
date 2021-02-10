//
//  ViewController.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/8/21.
//

import UIKit
import KeychainSwift

class LoginVC: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            //Dismiss keyboard
            passwordTextField.addTarget(self, action: #selector(donePressed), for: .primaryActionTriggered)
        }
    }
    
    ///Go to the next textField
    @objc func donePressed(){
        view.endEditing(true)
    }
    
    
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet{
            //Go to next text field
            userNameTextField.addTarget(self, action: #selector(nextPressed), for: .primaryActionTriggered)
        }
    }
    @objc func nextPressed(){
        passwordTextField.becomeFirstResponder()
    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(validateLogin), for: .touchUpInside)
            loginButton.layer.cornerRadius = 20
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //End editing when touched outside the text field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func validateLogin(){
        if userNameTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            handleError(for: .invalidInput)
            return
        }
        let keychain = KeychainSwift()
        if !keychain.allKeys.contains(userNameTextField.text!){
            handleError(for: .userNotFound)
            return
        }
        
        if let password = keychain.get(userNameTextField.text!){
            if password == passwordTextField.text!{
                keychain.set(userNameTextField.text!, forKey: Key.userLoggedIn)
                // Username and password successful
                goToMainTabBar()
            }
        }
    }
    ///Exit the login page and get to the tabBar by changing the rootviewcontroller of  window to TabBar
    func goToMainTabBar(){
        (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).currentUserName =  userNameTextField.text!
        
        let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.mainTabBar) as! UITabBarController
        UIApplication.shared.windows.first!.rootViewController = mainTabBar
    }
}

