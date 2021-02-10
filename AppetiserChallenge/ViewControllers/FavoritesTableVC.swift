//
//  FavoritesTableVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/10/21.
//

import UIKit
import CoreData

class FavoritesTableVC: UITableViewController {
    
    var favoriteTracks = [Track]()
    
    func refreshFavoriteTracks(){
        favoriteTracks = currentUser.favorites?.allObjects as! [Track]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshFavoriteTracks()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshFavoriteTracks()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.trackTVCell, for: indexPath) as! TrackTVCell

        // Configure the cell...
        refreshFavoriteTracks()
        let track = favoriteTracks[indexPath.row]
        cell.configureCell(for: track)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.detailViewVC, sender: indexPath.row)
    }
    
    ///Delete Track Via swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(favoriteTracks[indexPath.row])
            favoriteTracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            try? context.save()
        }
        refreshFavoriteTracks()
    }

    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let trackDetailVC = segue.destination as? TrackDetailVC{
            trackDetailVC.configureDetail(for:favoriteTracks[sender as! Int])
        }
    }
    
    // MARK: - CoreData Helpers
    
    var currentUserName = (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).currentUserName
    
    lazy var currentUser:User = getCurrentUser(from: container, with: currentUserName!).first!

    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    ///Get the current user from the scene delegate
    func getCurrentUser(from container:NSPersistentContainer,with userName:String) -> [User]{
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "userName = %@", userName)
            request.predicate = predicate
        return (try? container.viewContext.fetch(request)) ?? []
    }
}
