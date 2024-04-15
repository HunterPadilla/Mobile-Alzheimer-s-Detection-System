//
//  ClinicianViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit
import MessageUI

class ClinicianViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var ClinicianEmail: UITextField!
    
    @IBOutlet weak var ClinicianPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //These two lines are needed to disable the keyboard on Mobile phone for testing
        //Note that UITextFieldDelegate is also added to the class for this functionality
        self.ClinicianEmail.delegate = self
        self.ClinicianPhone.delegate = self
    }
    
    //The following functions disbale the keyboard when using a mobile phone for testing
    //done by either tapping return, or tapping on teh screen where the keyboard isnt covering
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

    @IBAction func ViewResultsButton(_ sender: Any) {
        guard let ResultsPage = storyboard? .instantiateViewController(withIdentifier: "Results") as? ResultsViewController else {
            return
        }
        present(ResultsPage, animated: true)
    }
    
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
