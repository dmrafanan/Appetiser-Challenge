//
//  RegisterVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/9/21.
//

import UIKit
import KeychainSwift
import CoreData

class RegisterVC:UIViewController{
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet{
            userNameTextField.addTarget(self, action: #selector(nextPressed), for: .primaryActionTriggered)
        }
    }
    ///Go to the next textField
    @objc func nextPressed(){
        passWordTextField.becomeFirstResponder()
    }
    
    @IBOutlet weak var passWordTextField: UITextField!{
        didSet{
            passWordTextField.addTarget(self, action: #selector(donePressed), for: .primaryActionTriggered)
        }
    }
    @objc func donePressed(){
        view.endEditing(true)
    }
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.layer.cornerRadius = 20
            registerButton.addTarget(self, action: #selector(touchRegisterButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //End editing when touched outside the text field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func touchRegisterButton(){
        if userNameTextField.text!.isEmpty || passWordTextField.text!.isEmpty || userNameTextField.text! == "userLoggedIn" {
            handleError(for: .invalidInput)
            return
        }
        let keychain = KeychainSwift()
        
        if keychain.allKeys.contains(userNameTextField.text!){
            handleError(for: .repeatUsername)
            return
        }
        
        let user = User(context: container.viewContext)
        user.userName = userNameTextField.text!
        try! container.viewContext.save()
        
        saveLoginCredentialsToKeychain()
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveLoginCredentialsToKeychain(){
        let keychain = KeychainSwift()
        keychain.set(passWordTextField.text!, forKey: userNameTextField.text!)
    }
}
