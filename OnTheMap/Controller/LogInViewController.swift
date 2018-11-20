//
//  LoginViewController.swift
//  PinSample
//
//  Created by Ammar AlTahhan on 15/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        API.postSession(username: emailTextField.text!, password: passwordTextField.text!) { (errString) in
            guard errString == nil else {
                self.showAlert(title: "Error", message: errString!)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
    }

}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
