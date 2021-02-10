//
//  TrackTVCell.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/9/21.
//

import UIKit

class TrackTVCell: UITableViewCell {
    
    var favoritePressedClosure:( ()->Void )!
    
    @IBOutlet weak var trackImageView: CustomImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!{
        didSet{
            favoriteButton.addTarget(self, action: #selector(favoritePressed), for: .touchUpInside)
        }
    }
    @objc func favoritePressed(){
        favoritePressedClosure()
    }
    
    func configureCell(for track:Track,favorite:Bool? = nil){
        if let artwork = track.artworkUrl100, let url = URL(string: artwork){
            trackImageView.fetchImage(from: url)
        }
        ///When trackName is nil, use collectionName instead
        if let trackName = track.trackName{
            trackNameLabel.text = trackName
        }else{
            trackNameLabel.text = track.collectionName
        }
        if track.trackPrice != -1{
            priceLabel.text = "$" + String(track.trackPrice)
        }else{
            priceLabel.text = ""
        }
        genreLabel.text = track.primaryGenreName ?? ""
        if favorite != nil{
            if favorite!{
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }else{
            favoriteButton.isHidden = true
        }
        
    }
}

//MARK: - Image Caching and placeholder support

///Uses a local placeholder when image is not available.
///Caches images to save data, automatically releases memory when the cache is full.
class CustomImageView:UIImageView {
    private var imageURL:URL?
    
    let cache = NSCache<NSURL, NSData>()
    
    func fetchImage(from url:URL){
        imageURL = url
        image = nil
        if let dataFromCache = cache.object(forKey: url as NSURL){
            image = UIImage(data: dataFromCache as Data)
        }else{
            DispatchQueue.main.async {
                self.image = UIImage(named: ImageName.noImageAvail)
            }
            NetworkManager.shared.fetchImageData(url: url){[weak self] result in
                switch result{
                case .failure(_):
                    self?.image = UIImage(named: ImageName.noImageAvail)
                    return
                case .success(let nsData):
                    self?.image = UIImage(named: ImageName.noImageAvail)
                    let data = nsData as Data
                    if let image = UIImage(data: data){
                        if url == self!.imageURL{
                            DispatchQueue.main.async {
                                self!.image = image
                            }
                            self?.cache.setObject(nsData as NSData, forKey: url as NSURL)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self?.image = UIImage(named: ImageName.noImageAvail)
                        }
                    }
                    
                }
            }
        }
    }
}

