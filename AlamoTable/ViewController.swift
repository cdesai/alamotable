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
    var arrayDict = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get status bar height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        // Add insets to Tableview top
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        let endpoint = "http://api.androidhive.info/contacts/"
        Alamofire.request(endpoint).responseJSON { (dataResponse) in
            if dataResponse.result.value != nil {
                let result = JSON(dataResponse.result.value!)
                
                if let contactData = result["contacts"].arrayObject {
                    self.arrayDict = contactData as! [[String: AnyObject]]
                }
                if self.arrayDict.count > 0 {
                    self.alamoView.reloadData()
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDict.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var dict = arrayDict[indexPath.row]
        cell.textLabel?.text = dict["name"] as? String
        cell.detailTextLabel?.text = dict["phone"]?["mobile"] as? String
        return cell
    }

}

