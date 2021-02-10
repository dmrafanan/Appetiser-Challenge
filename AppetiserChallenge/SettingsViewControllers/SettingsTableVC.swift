//
//  SettingsTableVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/10/21.
//

import UIKit
import KeychainSwift
import CoreData

class SettingsTableVC: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
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
        switch (indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.settingsCell, for: indexPath)
            cell.textLabel?.text = "Dark Mode"
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            var detailText = ""
            switch UIApplication.shared.windows[0].overrideUserInterfaceStyle {
            case .dark:
                detailText = "Dark"
            case .light:
                detailText = "Light"
            case .unspecified:
                detailText = "System"
            default:
                break
            }
            cell.detailTextLabel?.text = detailText
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.basicCell, for: indexPath)
            cell.textLabel?.text = "Logout"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.basicCell, for: indexPath)
            if let lastLogin = currentUser.lastLogin{
                cell.textLabel?.text = "Last login: " + lastLoginToTimeElapsed(date: lastLogin)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.row){
        case 0:
            performSegue(withIdentifier: SegueIdentifier.darkModeVC, sender: nil)
            
        case 1:
            currentUser.lastLogin = Date()
            try? container.viewContext.save()
            
            
            let keychain = KeychainSwift()
            keychain.delete(Key.userLoggedIn)
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifier.loginVC) as! LoginVC
            UIApplication.shared.windows.first!.rootViewController = loginVC
        default:
            break
        }
    }
    
    func lastLoginToTimeElapsed(date:Date)->String{
        let minutesElapsed = Int(floor((date.timeIntervalSinceNow/60) * -1))
        let hoursElapsed = Int(floor(((date.timeIntervalSinceNow/60)/60) * -1))
        let daysElapsed = hoursElapsed/24
        let monthsElapsed = daysElapsed/30
        let yearsElapsed = monthsElapsed/12
        //Minutes
        if minutesElapsed<60{
            if minutesElapsed<=1{
                return "About a minute ago"
            }else{
                return "\(minutesElapsed) minutes ago"
            }
        }
        //Hours
        if (hoursElapsed < 24){
            if hoursElapsed <= 1{
                return "An hour ago"
            }else{
                return "\(hoursElapsed) hours ago"
            }
            //Days
        }else if (daysElapsed <= 31){
            if ( daysElapsed == 1 ){
                return "A day ago"
            }else{
                return "\(hoursElapsed) days ago"
            }
            //Months
        }else if(monthsElapsed<12){
            if ( monthsElapsed == 1){
                return "A month ago"
            }else{
                return "\(monthsElapsed) months ago"
            }
            //Years
        }else{
            if yearsElapsed == 1{
                return "A year ago"
            }else{
                return "More than a year ago"
            }
        }
    }
    // MARK: - CoreData Helper
    var currentUserName = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).currentUserName
    
    lazy var currentUser:User = getCurrentUser(from: container, with: currentUserName!).first!
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getCurrentUser(from container:NSPersistentContainer,with userName:String) -> [User]{
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "userName = %@", userName)
        request.predicate = predicate
        return (try? container.viewContext.fetch(request)) ?? []
    }
}
