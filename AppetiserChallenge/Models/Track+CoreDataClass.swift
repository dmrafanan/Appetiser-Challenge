//
//  Track+CoreDataClass.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/10/21.
//
//

import Foundation
import CoreData

@objc(Track)
public class Track: NSManagedObject {
    ///Create copy of track on the CoreData
    func createCopy(on container: NSPersistentContainer,with user:User){
        let track = Track(context: container.viewContext)
        track.artistName = self.artistName
        track.artworkUrl100 = self.artworkUrl60
        track.artworkUrl60 = self.artworkUrl60
        track.country = self.country
        track.currency = self.currency
        track.longDescription = self.longDescription
        track.primaryGenreName = self.primaryGenreName
        track.trackName = self.trackName
        track.trackPrice = self.trackPrice
        track.trackTimeMillis = self.trackTimeMillis
        track.trackShortDescription = self.trackShortDescription
        track.collectionName = self.collectionName
        track.owner = user
    }
}

