//
//  NightModeTableVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/10/21.
//

import UIKit

class NightModeTableVC: UITableViewController {

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.basicCell, for: indexPath)
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "System"
        case 1:
            cell.textLabel?.text = "Dark"
        case 2:
            cell.textLabel?.text = "Light"
        default:
            break
        }
        var selectedIndexPath = Int()
        switch UIApplication.shared.windows[0].overrideUserInterfaceStyle{
        case .unspecified:
            selectedIndexPath = 0
        case .dark:
            selectedIndexPath = 1
        case .light:
            selectedIndexPath = 2
        default:
            break
        }
        if selectedIndexPath == indexPath.row{
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            tableView.window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            tableView.window?.overrideUserInterfaceStyle = .dark
        case 2:
            tableView.window?.overrideUserInterfaceStyle = .light
        default:
            break
        }
        UserDefaults.standard.setValue(indexPath.row, forKey: "DarkModeOption")
        tableView.reloadData()
    }
}
