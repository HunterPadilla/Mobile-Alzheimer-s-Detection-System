//
//  ResultsViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func MainMenuButton() {
        guard let MainMenu = storyboard? .instantiateViewController(withIdentifier: "MainMenu") as? HomeViewController else {
            return
        }
        present(MainMenu, animated: true)
    }

}
