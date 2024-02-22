//
//  LoginViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/10/24.
//


import Amplify
import AWSCognitoAuthPlugin
import UIKit
import SwiftUI

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            
            let username: String = UsernameTextField.text!
            let password: String = PasswordTextField.text!
            
    
            do {
                let signInResult = try await Amplify.Auth.signIn(
                    username: username,
                    password: password
                )
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                    print("Login credentials listed as: \(username) and \(password) ")
                    performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            } catch let error as AuthError {
                print("Sign in failed \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
            
            await fetchAttributes()
        }
        
    }
        
        
    func fetchAttributes() async {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            print("User attributes - \(attributes)")
        } catch let error as AuthError{
            print("Fetching user attributes failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
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
        
        //These two lines are needed to disable the keyboard on Mobile phone for testing
        //Note that UITextFieldDelegate is also added to the class for this functionality
        self.UsernameTextField.delegate = self
        self.PasswordTextField.delegate = self

    }
    
    
    
    
  
    
    
}





