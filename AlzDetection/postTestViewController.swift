//
//  UploadVideoViewController.swift
//  AlzDetection
//
//  Created by Hunter Padilla on 2/11/24.
//

import UIKit

class postTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func viewResultsButton(_ sender: Any) {
        performSegue(withIdentifier: "resultsButton", sender: self)
    }
    
    @IBAction func triggerMainMenuSegue(_ sender: Any) {
            guard let MainMenu = storyboard? .instantiateViewController(withIdentifier: "MainMenu") as? HomeViewController else {
                return
            }
            present(MainMenu, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


