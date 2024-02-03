//
//  ClinicianViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit
import MessageUI

class ClinicianViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var ClinicianEmail: UITextField!
    
    @IBOutlet weak var ClinicianPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func ViewResultsButton(_ sender: Any) {
        guard let ResultsPage = storyboard? .instantiateViewController(withIdentifier: "Results") as? ResultsViewController else {
            return
        }
        present(ResultsPage, animated: true)
    }
    
//    @IBAction func SendResults(_sender: Any) {
//        Task { @MainActor in
//            
//            let email: String = ClinicianEmail.text!
//            let phone: String = ClinicianPhone.text!
//            
//            if MFMailComposeViewController.canSendMail(){
//                let composeMail = MFMailComposeViewController()
//                composeMail.delegate = self
//                composeMail.setSubject("Patient Results Available")
//                composeMail.setToRecipients([email])
//                composeMail.setMessageBody(<#T##body: String##String#>, isHTML: true)
//                composeMail.addAttachmentData(<#T##attachment: Data##Data#>, mimeType: <#T##String#>, fileName: <#T##String#>)
//                present(composeMail, animated: true)
//                present(UINavigationController(rootViewController: composeMail), animated: true)
//                guard let ResultsSent = storyboard? .instantiateViewController(withIdentifier: "SentResults") as? ResultsSentViewController else {
//                    return
//                }
//                present(ResultsSent, animated: true)
//            }
//            
//            else {
//                print("Email failed to send")
//                return
//            }
//            
//        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
