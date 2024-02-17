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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    
  
    
    
}





