//
//  NetworkManager.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/8/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager{

    static let shared = NetworkManager()
    let url = URL(string: "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all")!
    func fetchTracks(completionHandler:@escaping (Result<[Track],ErrorType>)->Void) {
        AF.request(url, method: .get).validate().responseData{ response in
            switch response.result{
            case .failure(_):
                completionHandler(.failure(.fetchingError))
                break
            case .success(let data):
                guard let json = try? JSON(data: data),let resultCount = json["resultCount"].int64,let results = json["results"].array
                else{
                    completionHandler(.failure(.fetchingError))
                    return
                }
                var tracks = [Track]()
                for i in 0..<Int(resultCount){
                    let track = Track(entity: Track.entity(), insertInto: nil)
                    
                    track.artistName = results[i]["artistName"].string
                    track.artworkUrl100 = results[i]["artworkUrl100"].string
                    track.artworkUrl60 = results[i]["artworkUrl60"].string
                    track.country = results[i]["country"].string
                    track.currency = results[i]["currency"].string
                    track.longDescription = results[i]["longDescription"].string
                    track.primaryGenreName = results[i]["primaryGenreName"].string
                    track.trackName = results[i]["trackName"].string
                    track.trackPrice = results[i]["trackPrice"].double ?? -1
                    track.trackTimeMillis = results[i]["trackTimeMillis"].int64 ?? -1
                    track.trackShortDescription = results[i]["trackShortDescription"].string
                    track.collectionName = results[i]["collectionName"].string
                    
                    tracks.append(track)
                    completionHandler(.success(tracks))
                }
            }
        }
    }
    
    func fetchImageData(url:URL,completionHandler:@escaping (Result<Data,ErrorType>)->Void ){
        AF.request(url, method: .get).validate().responseData{response in
            switch response.result{
            case .failure(_):
            completionHandler(.failure(.fetchingError))
            case .success(let data):
            completionHandler(.success(data))
            }
        }
    }
}
