//
//  SettingsViewController.swift
//  SmartHomeApp
//
//  Created by a.belkov on 18/03/2018.
//  Copyright © 2018 Andrew Belkov. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var ipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ipField.text = UserDefaults.standard.string(forKey: "device-ip") ?? "192.168.4.1"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Actions
    
    @IBAction func saveIP(_ sender: Any) {
        
        let ip = self.ipField.text
        UserDefaults.standard.set(ip, forKey: "device-ip")
        
        self.navigationController?.popViewController(animated: true)
    }
}
