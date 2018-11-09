//
//  TabBarController.swift
//  
//
//  Created by 高家南 on 4/26/18.
//

import UIKit
import os.log

class TabBarController: UITabBarController {

    var website: String?
    var address: String?
    var name: String?
    var details: Dictionary<String,AnyObject>?
    var favRows: [FavRow]?
    var icon:UIImage?
    @IBOutlet weak var favButton: UIBarButtonItem!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("tabbarcontroller load")
        favRows = loadRows()
        if favRows != nil {
            if find(rows: self.favRows!, name: self.name!) {
                favButton.image = #imageLiteral(resourceName: "favorite-filled")
            }else{
                favButton.image = #imageLiteral(resourceName: "favorite-empty")
            }
        }else{
            favButton.image = #imageLiteral(resourceName: "favorite-empty")
        }
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func favPressed(_ sender: UIBarButtonItem) {
        let index = findAtIndex(rows: self.favRows!, name: self.name!)
        if  index != -1{
            print("remove")
            favRows?.remove(at: index)
            favButton.image = #imageLiteral(resourceName: "favorite-empty")
            saveFavRows()
        }else{
            if let newRow = FavRow(name: self.name!, icon: self.icon!, address: self.address!) {
                print("fav appended")
                favRows?.append(newRow)
                favButton.image = #imageLiteral(resourceName: "favorite-filled")
                saveFavRows()
            }else{
                print("instantiate fails")
            }
            
            
        }
    }
    @IBAction func twitterPressed(_ sender: UIBarButtonItem) {
        
        print("sharePressed")
        var link:String = "https://twitter.com/intent/tweet?text=Check out \(name!) located at \(address!) . Website:\(website!) &hashtags=TravelAndEntertainmentSearch"
        let linkEncoded = link.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: linkEncoded) {
            UIApplication.shared.open(url)
             print(url)
        }else{
            print("url nil")
        }
        
       
        
    }
    
    private func saveFavRows() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favRows, toFile: FavRow.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("rows successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save rows...", log: OSLog.default, type: .error)
        }
    }
    private func loadRows() -> [FavRow]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FavRow.ArchiveURL.path) as? [FavRow]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func find(rows: [FavRow], name: String) -> Bool{
        for row in rows{
            if row.name == name {
                return true
            }
        }
        return false
    }
    func findAtIndex(rows: [FavRow], name: String) -> Int{
        for (index, row) in rows.enumerated(){
            if row.name == name {
                return index
            }
        }
        return -1
    }
    
//    @IBAction func sharePressed(_ sender: Any){
//        print("sharePressed")
//        let link = "https://twitter.com/intent/tweet?text=Check out \(name!) located at \(address!). Website: \(website!)&hashtags=TravelAndEntertainmentSearch"
//        var url = URL(string: link)
//        UIApplication.shared.open(url!)
//    }
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
