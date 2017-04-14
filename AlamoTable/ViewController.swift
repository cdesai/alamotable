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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                self.arrayDict = json["tracks"]["items"].arrayObject as! [[String : Any]]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var dict = arrayDict[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String
        if let artists = dict["artists"] as? [[String: Any]] {
            if artists.count > 0 {
                for artist in artists {
                    cell.detailTextLabel?.text = (artist["name"] as? String)!
                }
            }
        }
        return cell
    }

}

