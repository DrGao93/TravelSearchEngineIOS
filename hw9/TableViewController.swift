//
//  TableViewController.swift
//  hw9
//
//  Created by 高家南 on 4/17/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import GoogleMaps

class TableViewController: UITableViewController {

    var rows = [row]()
    var selectedCell: IndexPath = []
    var toTransfer:  Dictionary<String, AnyObject>?
    var photosController: ViewControllerPhotos?
    var mapController:ViewControllerMap?
    var lat:Double?
    var lon: Double?
    var yelpNoMatch :Bool?
    var googleReviews: Array<review>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadSampleRows()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("table view")
        let cellIdentifier = "TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell else{
                fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        let row = rows[indexPath.row]
        cell.icon.image = row.icon
        cell.name.text = row.name
        cell.address.text = row.address
        cell.placeId = row.placeId
        //print(row.name!)
        // Configure the cell... fill in image name and address!

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the table was selected: \(indexPath.row)")
        selectedCell = indexPath
        let url = "http://hw8nodejs.us-east-2.elasticbeanstalk.com/hw8/getGoogleDetails?placeid=\(rows[indexPath.row].placeId!)"
        //print(url)
        Alamofire.request(url).responseJSON { response in
            
            
            
            if let json = (response.result.value as? Dictionary<String, AnyObject>) {
                //print("JSON: \(json)")
                self.toTransfer = json as! Dictionary<String, AnyObject>
                print("rotanasdfldksf")
                print(self.toTransfer)
                if let resultData =   try? JSONSerialization.data(withJSONObject: self.toTransfer!["result"]!, options: []) as? Data{
                    print("as data!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                    print(resultData!)
                    if let reviewsFrame = try? JSONDecoder().decode(detailsResult.self, from: resultData!){
                        print("PARSED!!!!!!!!!!!!!!!!!")
                        //print(reviewsFrame)
                        //print(reviewsFrame.reviews)
                        self.googleReviews = reviewsFrame.reviews
                        
                    }
                    
                    
                    
                }
                print("idddddddddd")
                print(self.toTransfer!["result"]!["place_id"]!)
                self.loadFirstPhotoForPlace(placeID: self.toTransfer!["result"]!["place_id"]! as! String)
                let geometry = self.toTransfer!["result"]!["geometry"]! as! Dictionary<String, AnyObject>
                print("geomtry")
                //print(geometry)
                self.lat = geometry["location"]!["lat"]! as? Double
                self.lon = geometry["location"]!["lng"]! as? Double
                print("self.lat")
                print(self.lat)
                let addressComponents = self.toTransfer!["result"]!["address_components"] as! Array<AnyObject>
                print("addressComponents:\(addressComponents)")
                let city = self.findCity(addressComponents: addressComponents)
                print("city:\(city)")
                let state = self.findState(addressComponents: addressComponents)
//                let addr1 = addressComponents[0]["short_name"]!
                let url = "http://hw8nodejs.us-east-2.elasticbeanstalk.com/hw8/getDetails?name=\(self.rows[self.selectedCell.row].name!)&address1=\(addressComponents[0]["short_name"]!!) \(addressComponents[1]["short_name"]!!)&city=\(city!)&state=\(state!)&country=US"
                print(url)
                Alamofire.request(url).responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                     print("Result: \(response.result)")
                    if let json = response.result.value as? Array<AnyObject>{
                        print("yelp match")
                        print("yelp\(json)")
                        let url = "http://hw8nodejs.us-east-2.elasticbeanstalk.com/hw8/getReview?place_id=\(json[0]["id"]!)"
                        print(url)
                        Alamofire.request(url).responseJSON { response in
                            if let json = response.result.value {
                                print("yelp review")
                                print(json)
                                
                            }else{
                                self.yelpNoMatch = true
                                self.performSegue(withIdentifier: "resultToDetails", sender: nil)
                            }
                        
                        }
                       
                    }else{
                        self.yelpNoMatch = true
                        self.performSegue(withIdentifier: "resultToDetails", sender: nil)
                    }
                    
                    
                }
                
                
            }
        }
    }
    func findCity(addressComponents: Array<AnyObject>) -> String?{
        for comp in addressComponents {
            let component = comp as! Dictionary<String, AnyObject>
            let type = component["types"]! as! Array<String>
             if  type[0] == "locality" {
                return component["short_name"] as! String
            }
        }
        return nil
    }
    func findState(addressComponents: Array<AnyObject>) -> String?{
        for comp in addressComponents {
            let component = comp as! Dictionary<String, AnyObject>
            let type = component["types"]! as! Array<String>
            if  type[0] == "administrative_area_level_1" {
                return component["short_name"] as! String
            }
        }
        return nil
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let tabBarController = segue.destination as? TabBarController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        tabBarController.name = rows[self.selectedCell.row].name
        tabBarController.address = rows[self.selectedCell.row].address
        tabBarController.website = self.toTransfer!["result"]!["website"] as? String
        
        
        tabBarController.icon = rows[self.selectedCell.row].icon
        let detailsViewController = tabBarController.viewControllers![0] as? ViewControllerDetails
        photosController = tabBarController.viewControllers![1] as? ViewControllerPhotos
        mapController = tabBarController.viewControllers![2] as? ViewControllerMap
        let reviewController = tabBarController.viewControllers![3] as? ViewControllerReview
        detailsViewController?.json = toTransfer

        mapController?.destLat = self.lat
        mapController?.destLon = self.lon
        
        photosController?.placeId = toTransfer!["result"]!["place_id"] as? String
        reviewController?.googleReviews = googleReviews
//        reviewController?.googleReviews = toTransfer!["result"]!["reviews"] as! Array<AnyObject>
//        print("photos.coutn before transfer")
//        print(photos.count)
//        photosController?.images = photos
        tabBarController.navigationItem.title = rows[selectedCell.row].name!
        
    }
    
    
    func loadFirstPhotoForPlace(placeID: String) {
        print("id")
        print("id:\(placeID)")
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("count:\(photos?.results.count)")
                for photoData in (photos?.results)! {
                    print("for")
                    
                    self.loadImageForMetadata(photoMetadata: photoData)
                    
                }
                
                

                
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata){
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                //print(photo)
                if let photo = photo{
                    print("appending")
                    
                    self.photosController?.images.append(photo)
                                    }
                
                
            }
        })
    }
    
    
    
//    private func loadSampleRows() {
//
//        //print("loadsamplerows")
//        guard let row1 = row(name: "Caprese Salad", iconUrl:"https://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png", address: "address1") else {
//            fatalError("Unable to instantiate row1")
//        }
//        
//        guard let row2 = row(name: "Chicken and Potatoes", iconUrl: "https://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png", address: "address2") else {
//            fatalError("Unable to instantiate row2")
//        }
//
//
//
//        rows += [row1, row2]
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    

}
