//
//  LoginViewController.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 20.09.22.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    //Variables to set status of textfields
    var emailTextFieldEmpty = true
    var passwordTextFieldEmpty = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup buttons, textfields, labels and hide activityIndicator
        setupButtons(button: loginButton)
        setupButtons(button: signUpButton)
        setupTextFields(textfield: emailTextField)
        setupTextFields(textfield: passwordTextField)
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
        //So password can be inserted safely
        passwordTextField.isSecureTextEntry = true
        //Set delegates for textfields
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Empty textfields
        emailTextField.text = ""
        passwordTextField.text = ""
        //Disable login-button
        loginButton.isEnabled = false
    }
    
    //Method for tapping login button
    @IBAction func loginButtonTapped(_ sender: Any) {
        //Check if url is reachable
        if verifyURL(url: Client.Endpoints.login.url) == true {
            //En-/Disable UIElements
            loadingStatus(status: true, activityIndicator: activityIndicator, label: loadingLabel, button: loginButton)
            Client.login(mail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { success, error in
                if success {
                    //En-/Disable UIElements
                    loadingStatus(status: false, activityIndicator: self.activityIndicator, label: self.loadingLabel, button: self.loginButton)
                    DispatchQueue.main.async {
                        //get locations
                        self.getStudentLocations()
                        //activity Indicator shall disappear
                        self.activityIndicator.isHidden = true
                        //to reset for later login
                        self.emailTextFieldEmpty = true
                        self.passwordTextFieldEmpty = true
                    }
                } else {
                    //Present Alert in case of error
                    DispatchQueue.main.async {
                        self.presentErrorAlert(error: "Login Error", message: error!.localizedDescription)
                    }
                    //En-/Disable UIElements
                    loadingStatus(status: false, activityIndicator: self.activityIndicator, label: self.loadingLabel, button: self.loginButton)
                }
            }
        }
        //If url is not reachable show error alert
        else {
            DispatchQueue.main.async {
                self.presentErrorAlert(error: "Network Error", message: "Please try again later")
            }
        }
    }
    
    //Method for tapping sign-Up-Button
    @IBAction func signUpButtonTapped(_ sender: Any) {
        //Check if url is reachable
        if verifyURL(url: Client.Endpoints.signUp.url) == true {
            UIApplication.shared.open(Client.Endpoints.signUp.url)
        }
        //If not, show error alert
        else {
            DispatchQueue.main.async {
                self.presentErrorAlert(error: "Network Error", message: "Please try again later")
            }
        }
    }
    
    //Method to load student locations
    func getStudentLocations() {
        Client.loadStudentLocations { (success, error) in
            if success {
                //Perform segue to next screen
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.presentErrorAlert(error: error?.localizedDescription ?? "", message: "Login failed")
            }
        }
    }
    
    //Method to show Alert
    func presentErrorAlert(error: String, message: String) {
        let alertViewController = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertViewController, animated: true)
    }
    
    
    //Enable Button dependent on textfield-entry
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //check which Textfield
        if textField == emailTextField {
            let text = emailTextField.text ?? ""
            guard let textRange = Range(range, in: text) else { return false }
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //check if anything was entered and set status of variables
            if updatedText.isEmpty && updatedText == "" {
                emailTextFieldEmpty = true
            } else {
                emailTextFieldEmpty = false
            }
        }
        
        //check which Textfield
        if textField == passwordTextField {
            let text = passwordTextField.text ?? ""
            guard let textRange = Range(range, in: text) else { return false }
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            //check if anything was entered and set status of variables
            if updatedText.isEmpty && updatedText == "" {
                passwordTextFieldEmpty = true
            } else {
                passwordTextFieldEmpty = false
            }
        }
        //Enable login-Button dependent on Textfield-input
        if emailTextFieldEmpty == false && passwordTextFieldEmpty == false {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
        return true
        
    }
}

