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
    weak var clinicianViewController: ClinicianViewController?
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
        let key: String
    }
    var storageItems = [Results]()
    var listResult : [StorageListResult?] = []
    var itemSelected: ((String) -> Void)?
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
            updateTable()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClinician",
           let clinicianVC = segue.destination as? ClinicianViewController,
           let selectedItemKey = sender as? String {
            clinicianVC.selectedItemKey = selectedItemKey
        }
    }

    
    func updateTable() {
        storageItems = testList.map {key in
            Results(title: key, imageName: "AppIcon", key: key)
        }
        DispatchQueue.main.async {
            self.Table.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Results = storageItems[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItemKey = storageItems[indexPath.row].key
        itemSelected?(selectedItemKey)
        performSegue(withIdentifier: "showClinician", sender: selectedItemKey)
    }
}
