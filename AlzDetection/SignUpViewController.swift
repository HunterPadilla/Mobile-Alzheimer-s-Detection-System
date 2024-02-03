//
//  SignUpViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/12/24.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextFIeld: UITextField!
    
    
    @IBOutlet weak var ConfirmationCodeTextField: UITextField!
    
    
    @IBAction func cancelSignup(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SignupButton(_ sender: Any) {
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
                } else {
                    print("SignUp Complete")
                }
            } catch let error as AuthError {
                print("An error occurred while registering a user \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
            
            
            
            
            }
        
        
        
       
            
            
    }
    
    @IBAction func ConfirmationCodeButton(_ sender: Any) {
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
    override func viewDidLoad() {
    super.viewDidLoad()
    }
    
    
}

