//
//  LoginViewController.swift
//  FinalProject
//
//  Created by 王文贝 on 2019/12/9.
//  Copyright © 2019 Wenbei Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerSwitch: UISwitch!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var newuserLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    let userModel = travelModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        loginButton.isEnabled = false
        usernameText.text = "\n"
        passwordText.text = "\n"
        
        if userModel.loggin{
            print ("already log in")

            newuserLabel.alpha = 0
            passwordLabel.alpha = 0
            usernameLabel.alpha = 0
            usernameText.alpha = 0
            passwordText.alpha = 0
            registerSwitch.alpha = 0
            loginLabel.text = "Saved"
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func usernameReturn(_ sender: UITextField) {
        if let pw = passwordText.text {
            if pw == "\n"{
                usernameText.resignFirstResponder()
                passwordText.becomeFirstResponder()
            }
            else {
                usernameText.resignFirstResponder()
                enableLoginButton()
            }
        }
       
    }
    
    @IBAction func passwordReturn(_ sender: UITextField) {
        passwordText.resignFirstResponder()
        enableLoginButton()
    }
    
    func enableLoginButton(){
        if let u = usernameText.text{
            if let p = passwordText.text {
                loginButton.isEnabled = u.count > 0 && p.count > 0
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIBarButtonItem) {
          let password = passwordText.text ?? ""
          let username = usernameText.text ?? ""
          let newUser = registerSwitch.isOn
            
        // if it is a new user and have repeated name
          if newUser && userModel.checkRepeatUsername(username: username){
              let alert = UIAlertController(title: "Warning", message: "The username you have entered already exits! Try a new username.", preferredStyle: .alert)
              let warning = UIAlertAction(title: "OK", style: .cancel, handler: nil)
              passwordText.text = ""
              usernameText.text = ""
              alert.addAction(warning)
              present(alert, animated: true)
              return
          }
        // a old user but not verifed
          else if !newUser && !userModel.verify(username: username, password: password){
            let alert = UIAlertController(title: "Warning", message: "The username and password you have entered do not match with the record! Try again.", preferredStyle: .alert)
            let warning = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            passwordText.text = ""
            usernameText.text = ""
            alert.addAction(warning)
            present(alert, animated: true)
            return
        }
        // a new user and a new name
          else if newUser && !userModel.checkRepeatUsername(username: username){
        }
            // a old user and verified
          else if !newUser && userModel.verify(username: username, password: password){
            // set tempUser to the user
            userModel.findUser(username: username)
        }
 
        userModel.loggin =  true
        print ("loggin is true")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        
        // close the view controller
        
          dismiss(animated: true, completion: nil)
    }
    
}
