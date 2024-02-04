//
//  ResultsViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit

class ResultsViewController: UIViewController {
    let results = ["Trial 1", "Trial 2", "Trial 3", "Trial 4", "Trial 5"]

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
    
extension ResultsViewController : UITableViewDataSource {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell; cell.textLabel?.text = "\results[indexPath.row])"
        return cell    }
    }
    

