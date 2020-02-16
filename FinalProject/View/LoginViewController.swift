

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    let userModel = travelModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        userModel.getUsers()
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        loginButton.isEnabled = false
        usernameText.text = "\n"
        passwordText.text = "\n"
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
            
        for oneuser in userModel.users {
            if oneuser.getFirstName() == password && oneuser.getLastName() == username {
                userModel.currentUser = oneuser
            }
        }
                
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
}

