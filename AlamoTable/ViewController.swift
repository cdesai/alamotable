//
//  ViewController.swift
//  AlamoTable
//
//  Created by Chinmay Desai on 4/4/17.
//  Copyright © 2017 Chinmay Desai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlamoTableViewController: UITableViewController, UISearchBarDelegate {

    var tracks = [Track]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set custom row height of the cell
        tableView.rowHeight = 100
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        
        let convertedKeywords = keywords?.replacingOccurrences(of: " ", with: "+")

        // Endpoint to grab all tracks for the search keyword
        let searchURL = "https://api.spotify.com/v1/search?q=\(convertedKeywords!)&type=track"
        tracks = []
        getRequest(searchURL: searchURL)
        self.view.endEditing(true)
    }
    
    func getRequest(searchURL: String) {
        // GET request using SwiftyJSON method for Alamofire
        Alamofire.request(searchURL).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                // Get the JSON object
                let json = JSON(value)
                
                // Extract tracks as an Array of Dictionaries from items
                if let items = json["tracks"]["items"].arrayObject as? [[String: Any]]{
                    for item in items {
                        
                        // Extract and store artist name for each track to Track object
                        let track = Track()
                        if let artists = item["artists"] as? [[String: Any]] {
                            for artist in artists {
                                track.artistName = artist["name"]! as! String
                            }
                        }
                        
                        // Extract and store album art for each track to Track object
                        if let album = item["album"] as? [String: Any] {
                            
                            if let images = album["images"] as? [[String: Any]] {
                                
                                // Extract the first 640x640 sized image url
                                let image = images.first!
                                
                                // Fetch actual image from the image url and store it as a UIImage
                                let albumImageURL =  URL(string: image["url"] as! String)
                                do {
                                    let albumImageData = try Data(contentsOf: albumImageURL!)
                                    let albumImage = UIImage(data: albumImageData )
                                    track.albumImage = albumImage!
                                } catch {
                                    print(error)
                                }
                                
                                // Extract and store track name to Track object
                                track.trackName = item["name"]! as! String
                                
                                // Extract and store previewURL i.e. url of the preview track to play later and store to the Track object
                                track.previewURL = item["preview_url"]! as! String
                                
                                
                            }
                        }
                        
                        // Append the track object to array
                        self.tracks.append(track)
                    }
                }
                // If our GET request was successful and there are tracks then reload table view
                if self.tracks.count > 0 {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackViewCell
        
        let trackInfo = tracks[indexPath.row]
        
        // Set custom cell sections with track object properties
        cell.albumImage.image = trackInfo.albumImage
        cell.trackName.text = trackInfo.trackName
        cell.artistName.text = trackInfo.artistName
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tvc = segue.destination as! TrackPlayer
        tvc.previewTrack = tracks[(self.tableView.indexPathForSelectedRow?.row)!]
    }

}

