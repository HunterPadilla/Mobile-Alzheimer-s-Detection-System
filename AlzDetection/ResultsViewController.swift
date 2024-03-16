//
//  ResultsViewController.swift
//  AlzDetection
//
//  Created by Sunny Chen on 1/20/24.
//

import UIKit
import Amplify
import AWSS3

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var Table: UITableView!
    @IBAction func MainMenuButton() {
        guard let MainMenu = storyboard? .instantiateViewController(withIdentifier: "MainMenu") as? HomeViewController else {
            return
        }
        present(MainMenu, animated: true)
    }
    
    
    
    struct Results {
        let title: String
        let imageName: String
    }
    var listResult : [StorageListResult?] = []
    let trialList : [Results] = [
        Results(title: "Trial 1", imageName: "AppIcon"),
        Results(title: "Trial 2", imageName: "AppIcon"),
        Results(title: "Trial 3", imageName: "AppIcon"),
        Results(title: "Trial 4", imageName: "AppIcon"),
        Results(title: "Trial 5", imageName: "AppIcon")
    ]
    var testList = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Table.dataSource = self
        Table.delegate = self
        Task{
            //let userID = "\(try await Amplify.Auth.getCurrentUser().userId)"
            //let options = StorageListRequest.Options(accessLevel: .guest ,targetIdentityId: "userID", pageSize: 1000)
            let options = StorageListRequest.Options(pageSize: 1000)
            let listResult = try await Amplify.Storage.list(options: options)
            listResult.items.forEach { item in
                print("Key:\(item.key)")
                testList.append(item.key)
                
            }
            testList.removeFirst(1)
            dump(testList)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Results = trialList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! TableViewCell

        cell.label.text = Results.title
        cell.iconImageView.image = UIImage(named: Results.imageName)
        cell.iconImageView.layer.cornerRadius = cell.iconImageView.frame.height / 6
        cell.iconImageView.layer.borderWidth = 1
        cell.iconImageView.layer.masksToBounds = false
        cell.iconImageView.layer.borderColor = UIColor.white.cgColor
        cell.iconImageView.clipsToBounds = true
        
        return cell
    }
}
