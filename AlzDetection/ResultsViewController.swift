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
    
    var listResult : [StorageListResult?] = []

    let trialList = ["Trial 1", "Trial 2", "Trial 3", "Trial 4", "Trial 5"]
    
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
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        
        cell.textLabel!.text = trialList[indexPath.row]
        return cell
    }
}
