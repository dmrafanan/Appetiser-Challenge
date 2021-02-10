//
//  TrackDetailVC.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/10/21.
//

import UIKit

class TrackDetailVC: UIViewController {
    
    @IBOutlet weak var trackNameLabel: UILabel!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    var trackNameText = ""
    
    var detailText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackNameLabel.text = trackNameText
        detailTextView.text = detailText
        // Do any additional setup after loading the view.
    }
    
    func configureDetail(for track:Track){
        trackNameText = track.trackName ?? track.collectionName ?? "No Title"
        detailText = track.longDescription ?? track.trackShortDescription ?? track.primaryGenreName ?? "No Description"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
