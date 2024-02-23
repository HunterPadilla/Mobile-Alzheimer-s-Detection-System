//
//  InstructionsViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit

class InstructionsViewController: UIViewController {

    
    @IBAction func cancelTestButton(_ sender: Any) {
        performSegue(withIdentifier: "instructionsCancel", sender: self)
    }
    
    @IBAction func beginTestButton(_ sender: Any) {
        performSegue(withIdentifier: "instructionsConfirm", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
