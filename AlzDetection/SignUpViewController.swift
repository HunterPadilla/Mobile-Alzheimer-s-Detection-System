//
//  SignUpViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/12/24.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextFIeld: UITextField!
    
    @IBOutlet weak var ConfirmationCodeButtonOutlet: UIButton!
    
    @IBOutlet weak var ConfirmationCodeTextField: UITextField!
    
    @IBOutlet weak var ConfirmationLabel: UILabel!
    
    @IBOutlet weak var UILoadingView: UIImageView!
    
    @IBAction func cancelSignup(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SignupButton(_ sender: Any) {
        
        UILoadingView.isHidden = false
        
        Task { @MainActor in
            
            let username: String = UsernameTextField.text!
            let password: String = PasswordTextFIeld.text!
            let email: String = UsernameTextField.text!
           
            
            //func signUp(username: String, password: String, email: String) async {
            
            let userAttributes = [AuthUserAttribute(.email, value: email)]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            do {
                let signUpResult = try await Amplify.Auth.signUp(
                    username: username,
                    password: password,
                    options: options
                )
                if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                    UILoadingView.isHidden = true
                    ConfirmationLabel.isHidden = false
                    ConfirmationCodeButtonOutlet.isHidden = false
                    ConfirmationCodeTextField.isHidden = false
                    
                } else {
                    print("SignUp Complete")
                    UILoadingView.isHidden = true
                }
            } catch let error as AuthError {
                print("An error occurred while registering a user \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
            
            
            
            
            }
        
        
        
       
            
            
    }
    
    @IBAction func ConfirmationCodeButton(sender: UIButton) {
        Task { @MainActor in
            
            let username: String = UsernameTextField.text!
            let confirmationCode: String = ConfirmationCodeTextField.text!
            
            //func confirmSignUp(for username: String, with confirmationCode: String) async {
            do {
                let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: confirmationCode
                )
                print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
                performSegue(withIdentifier: "confirmationPassed", sender: nil)
            } catch let error as AuthError {
                print("An error occurred while confirming sign up \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
            //}
            
        }
    }
    
        
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //The following functions disbale the keyboard when using a mobile simulator
    //done by either tapping return, or tapping on teh screen where the keyboard isnt covering
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These lines help enable the Loading gif in the signup page
        let loadingGif = UIImage.gifImageWithName("loadingGif")
        UILoadingView.image = loadingGif
        UILoadingView.isHidden = true
        
        //These three lines are needed to disable the keyboard on Mobile phone for testing
        //Note that UITextFieldDelegate is also added to the class for this functionality
        self.UsernameTextField.delegate = self
        self.PasswordTextFIeld.delegate = self
        self.ConfirmationCodeTextField.delegate = self
    
        
    }
    
    
}




