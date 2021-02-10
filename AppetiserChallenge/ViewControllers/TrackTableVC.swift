//
//  TrackTableVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/9/21.
//

import UIKit
import CoreData

class TrackTableVC: UITableViewController {
            
    var tracks = [Track]()
    
    var favoriteTracks = [Track]()
    
    func refreshFavoriteTracks(){
        favoriteTracks = currentUser.favorites?.allObjects as! [Track]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshFavoriteTracks()
        tableView.tableFooterView?.isHidden = false
        NetworkManager.shared.fetchTracks{ [self] result in
            switch result{
            case .failure(let errorType):
                handleError(for: errorType)
            case .success(let resultTracks):
                tracks = resultTracks
                DispatchQueue.main.async {
                    tableView.tableFooterView?.isHidden = true
                    tableView.reloadData()
                }
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshFavoriteTracks()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.trackTVCell, for: indexPath) as! TrackTVCell

        let track = tracks[indexPath.row]
        cell.configureCell(for: track, favorite: isAFavoriteTrack(track))
        ///Called when favoriteButton is pressed inside the cell
        cell.favoritePressedClosure = { [self] in
            ///If selected favorite track and its already in the favoriteTracks, delete it from the favoriteTracks
            if let trackToDelete = favoriteTracks.filter({favTrack in
                return favTrack.trackName == tracks[indexPath.row].trackName && favTrack.collectionName == tracks[indexPath.row].collectionName
            }).first{
                container.viewContext.delete(trackToDelete)
                try? container.viewContext.save()
                refreshFavoriteTracks()
                ///Else if it is not yet on the favoriteTrack, add it on the favoriteTrack
            }else{
                tracks[indexPath.row].createCopy(on: container, with: currentUser)
                try? container.viewContext.save()
                refreshFavoriteTracks()
            }
            tableView.reloadData()
        }
        return cell
    }
    
    func isAFavoriteTrack(_ track:Track)->Bool{
        for favTrack in favoriteTracks{
            if favTrack.trackName == track.trackName && favTrack.collectionName == track.collectionName{
                return true
            }
        }
        return false
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.detailViewVC, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let trackDetailVC = segue.destination as? TrackDetailVC{
            trackDetailVC.configureDetail(for: tracks[sender as! Int])
        }
    }
    

    
    // MARK: - Core Data helpers
    
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


