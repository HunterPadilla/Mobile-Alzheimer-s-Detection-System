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

class LoginViewController: UIViewController {
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func LoginButton(_ sender: Any) {
        Task { @MainActor in
            let username: String = UsernameTextField.text!
            let password: String = PasswordTextField.text!
            
            //func signIn(username: String, password: String) async {
            do {
                let signInResult = try await Amplify.Auth.signIn(
                    username: username,
                    password: password
                )
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                    performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            } catch let error as AuthError {
                print("Sign in failed \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
        
        
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    
  
    
    
}





