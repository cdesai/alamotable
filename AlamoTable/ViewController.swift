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

class AlamoTableViewController: UITableViewController {

    @IBOutlet var alamoView: UITableView!
    var arrayDict = [[String: Any]]()
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get status bar height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // Add insets to Tableview top
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        let endpoint = "https://api.spotify.com/v1/search?q=Chillstep&type=track&offset=0"
        Alamofire.request(endpoint).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let items = json["tracks"]["items"].arrayObject as? [[String: Any]]{
                    for item in items {
                        let track = Track()
                        if let artists = item["artists"] as? [[String: Any]] {
                            for artist in artists {
                                track.artistName = artist["name"]! as! String
                            }
                        }
                        if let album = item["album"] as? [String: Any] {
                            if let images = album["images"] as? [[String: Any]] {
                                let image = images.first!
                                let albumImageURL =  URL(string: image["url"] as! String)
                                do {
                                    let albumImageData = try Data(contentsOf: albumImageURL!)
                                    let albumImage = UIImage(data: albumImageData )
                                    track.albumImage = albumImage!
                                } catch {
                                    print(error)
                                }
                                track.trackName = item["name"]! as! String
                                track.previewURL = item["preview_url"]! as! String
        
                                
                            }
                        }
                        self.tracks.append(track)
                    }
                }
                if self.arrayDict.count > 0 {
                    self.alamoView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackViewCell
        let dict = tracks[indexPath.row]
        cell.albumImage.image = dict.albumImage
        cell.trackName.text = dict.trackName
        cell.artistName.text = dict.artistName
//        cell.textLabel?.text = dict.trackName
//        cell.detailTextLabel?.text = dict.artistName
//        if let artists = dict.artistName as? [[String: Any]] {
//            if artists.count > 0 {
//                for artist in artists {
//                    cell.detailTextLabel?.text = (artist["name"] as? String)!
//                }
//            }
//        }
        return cell
    }

}

