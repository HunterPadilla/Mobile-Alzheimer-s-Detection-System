//
//  HomeViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 1/12/24.
//

import UIKit
import Amplify
import AWSCognitoAuthPlugin

class HomeViewController: UIViewController {

    @IBOutlet weak var WelcomeDisplayLabel: UILabel!
    
    @IBAction func SignoutButton(_ sender: Any) {
        Task { @MainActor in
            
            let result = await Amplify.Auth.signOut()
            guard let signOutResult = result as? AWSCognitoSignOutResult
            else {
                print("Signout failed")
                return
            }
            
            print("Local signout successful: \(signOutResult.signedOutLocally)")
            switch signOutResult {
            case .complete:
                // Sign Out completed fully and without errors.
                print("Signed out successfully")
                self.dismiss(animated: true)
                
            case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
                // Sign Out completed with some errors. User is signed out of the device.
                
                if let hostedUIError = hostedUIError {
                    print("HostedUI error", (String(describing: hostedUIError)))
                    self.dismiss(animated: true)
                }
                
                if let globalSignOutError = globalSignOutError {
                    // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                    print("GlobalSignOut error", (String(describing: globalSignOutError)))
                    self.dismiss(animated: true)
                }
                
                if let revokeTokenError = revokeTokenError {
                    // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                    print("Revoke token error", (String(describing: revokeTokenError)))
                    self.dismiss(animated: true)
                }
                
            case .failed(let error):
                // Sign Out failed with an exception, leaving the user signed in.
                print("SignOut failed with \(error)")
            }
        }
        
    }
            
            
            
            
    @IBAction func BeginTestButton(_ sender: Any) {
        guard let InstructionsPage = storyboard? .instantiateViewController(withIdentifier: "Instructions") as? InstructionsViewController else {
            return
        }
        present(InstructionsPage, animated: true)
    }
    
    
    @IBAction func ViewResultsButton(_ sender: Any) {
        guard let ResultsPage = storyboard? .instantiateViewController(withIdentifier: "Results") as? ResultsViewController else {
            return
        }
        present(ResultsPage, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
