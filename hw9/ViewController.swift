//
//  ViewController.swift
//  hw9
//
//  Created by 高家南 on 4/11/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import GooglePlaces

import McPicker
import SwiftSpinner
import Alamofire


class ViewController: UIViewController {

    @IBOutlet weak var containerFavorite: UIView!
    @IBOutlet weak var containerSearch: UIView!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
    }
    
    @IBAction func segmentControl(_ sender: Any) {
        if segmentController.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.1, animations: {
                self.containerSearch.alpha = 1
                self.containerFavorite.alpha = 0
                
            })
        }
        else {
            let favTabController = self.childViewControllers.first as! ViewControllerFavTab
            let favController = favTabController.childViewControllers.first as! TableViewControllerFavorite
            favTabController.viewDidLoad()
            favController.update()
            UIView.animate(withDuration: 0.1, animations: {
                self.containerSearch.alpha = 0
                self.containerFavorite.alpha = 1
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "segueToFav"{
            if let favController = segue.destination as? TableViewControllerFavorite{
                print("updateing")
                favController.update()
            }
            
        }
        let searchViewController = self.childViewControllers.last as? ViewControllerSearch
        let searchResult = searchViewController?.searchResult
        if segue.identifier == "searchToResult" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            guard let ResultsTableController = segue.destination as? TableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            for item in searchResult!{
                guard let place = item as? [String: AnyObject] else{
                    fatalError("sorry cast fails")
                }
                
                guard let row = row(name: place["name"] as! String, iconUrl:place["icon"] as! String, address: place["vicinity"] as! String, placeId: place["place_id"] as! String) else {
                    fatalError("Unable to instantiate row")
                }
                ResultsTableController.rows += [row]
            }
        }
        
        
        
    }
    
    
   
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



