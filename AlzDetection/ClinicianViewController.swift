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
//
//        //These two lines are needed to disable the keyboard on Mobile phone for testing
//        //Note that UITextFieldDelegate is also added to the class for this functionality
//        self.ClinicianEmail.delegate = self
//        self.ClinicianPhone.delegate = self
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
    
    @IBAction func SendResults(_sender: Any) {
        guard self.isViewLoaded && (self.view.window != nil) else {
            print("View is not in the window hierarchy.")
            return
        }
        
        Task { @MainActor in
            
            //let email: String = ClinicianEmail.text!
            //let phone: String = ClinicianPhone.text!
            let email: String = "schen2014@fau.edu"
            
            let htmlContent = "<html><body><p>Your patient Sunny is sending you results from a new trial!</p></body></html>"
            
            //let fileData: Data? = await fetchFileData()
            //let mimeType = "application/mp4"
            //let fileName = "Results.mp4"
            
            if MFMailComposeViewController.canSendMail(){
                let composeMail = MFMailComposeViewController()
                composeMail.mailComposeDelegate = self
                composeMail.setSubject("Patient Results Available")
                composeMail.setToRecipients([email])
                composeMail.setMessageBody(htmlContent, isHTML: true)
                
                //if let fileData = fileData {
                //    composeMail.addAttachmentData(fileData, mimeType: mimeType, fileName: fileName)
                //}
                DispatchQueue.main.async{
                    self.present(composeMail, animated: true)
                }
            }
            else {
                let alert = UIAlertController(title: "Mail Not Available", message: "Mail services are not available. Please configure an email account in the Mail app to send emails.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "There was an error sending your email: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if result == .sent {
                guard let resultsSentVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultsSent") as? ResultsSentViewController
                else {
                    return
                }
                self.present(resultsSentVC, animated: true)
            }
            else if result == .cancelled {
                let cancelAlert = UIAlertController(title: "Email cancelled.", message: "Your clinician has not been notified about your results.", preferredStyle: .alert)
                self.present(cancelAlert, animated: true, completion: nil)
            }
        }
    }
}
