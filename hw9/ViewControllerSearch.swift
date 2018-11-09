//
//  ViewControllerSearch.swift
//  hw9
//
//  Created by 高家南 on 4/21/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import GooglePlaces

import McPicker
import SwiftSpinner
import Alamofire


class ViewControllerSearch: UIViewController {
    
    
    
    var searchResult: Array<AnyObject>?
    var myLat: Double?
    var myLon: Double?
    
    
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var category: McTextField!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var distance: UITextField!
    
    //    @IBOutlet weak var keyword: UITextField!
//    @IBOutlet weak var distance: UITextField!
//    @IBOutlet weak var from: UITextField!
//    @IBOutlet weak var category: McTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.category.text = "Default"
        let data: [[String]] = [["Default", "Airport", "Amusement Park", "Aquarium","Art Gallery","Bakery","Bar","Beauty Salon","Bowling Alley","Bus Station","Cafe","Campground","Car Rental","Casino","Lodging","Movie Theater","Museum","Night Club","Park","Parking","Restaurant","Shopping Mall","Stadium","Subway Station","Taxi Stand","Train Station","Travel Agency","Zoo"]]
        let mcInputView = McPicker(data: data)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        category.inputViewMcPicker = mcInputView
        from.text = "Your location"
        
        distance.placeholder = "Enter distance (default 10 miles)"
        
        category.doneHandler = { [weak category] (selections) in
            category?.text = selections[0]!
        }
        category.selectionChangedHandler = { [weak category] (selections, componentThatChanged) in
            category?.text = selections[componentThatChanged]!
        }
        category.cancelHandler = { [weak category] in
            category?.text = "Default"
        }
        category.textFieldWillBeginEditingHandler = { [weak category] (selections) in
            if category?.text == "" {
                // Selections always default to the first value per component
                category?.text = selections[0]
            }
        }
        
    }
    
    
    
    @IBAction func clearClicked(_ sender: UIButton) {
        keyword.text = ""
        category.text = "Default"
        distance.text = ""
        from.text = "Your location"
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        
        
        print("parent name is \(parent?.navigationItem.title!)")
        if(keyword.text == ""){
            
            var label:UILabel
            label = UILabel(frame: CGRect(x:0, y: 0, width: 150, height: 21))
            label.center = CGPoint(x: 200, y: 585)
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.textAlignment = .center
            label.text = "Keyword cannot be empty"
            label.backgroundColor = UIColor.darkGray
            label.tag = 100
            parent?.view.addSubview(label)
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.removeErrorMsg), userInfo: nil, repeats: true)
        }
        else{
            SwiftSpinner.show("Searching...")
            if(from.text == "Your location"){
                Alamofire.request("http://ip-api.com/json").responseJSON { response in
                    //                    print("Request: \(String(describing: response.request))")   // original url request
                    //                    print("Response: \(String(describing: response.response))") // http url response
                    //                    print("Result: \(response.result)")                         // response serialization result
                    //                    print(response)
                    var radiusInMeter: Int
                    if let radius:Int = Int(self.distance.text!){
                        radiusInMeter =  radius*1609
                        
                    }else{
                        radiusInMeter = 16090
                    }
                    if let json = (response.result.value as? Dictionary<String, AnyObject>){
                        self.myLat = json["lat"] as! Double
                        self.myLon = json["lon"] as! Double
                        var url:String? = "http://hw8nodejs.us-east-2.elasticbeanstalk.com/hw8/getNearby?location=\(self.myLat!),\(self.myLon!)&radius=\(radiusInMeter)&type=\(self.category.text!)&keyword=\(self.keyword.text!)"
                        print(url)
                        Alamofire.request(url!).responseJSON { response in
                            if let data = (response.result.value as? Dictionary<String, AnyObject>){
                                let arr = data["results"]! as? Array<AnyObject>
                                self.searchResult = arr!
                                print(arr![0]["name"]!)
                                self.parent?.performSegue(withIdentifier: "searchToResult", sender: nil)
                                
                                SwiftSpinner.hide()
                            }
                            
                        }
                        
                    }
                    
                }
            }
            else{
                var radiusInMeter: Int
                if let radius:Int = Int(self.distance.text!){
                    radiusInMeter =  radius*1609
                    
                }else{
                    radiusInMeter = 16090
                }
                
                var url : String!
                url = "http://hw8nodejs.us-east-2.elasticbeanstalk.com/hw8/geoNearby?location=\(self.from.text!)&radius=\(radiusInMeter)&type=\(self.category.text!)&keyword=\(self.keyword.text!)"
                let urlEncoded = url.replacingOccurrences(of: " ", with: "%20")
                print(urlEncoded)
                Alamofire.request(urlEncoded).responseJSON { response in
                    if let data = (response.result.value as? Dictionary<String, AnyObject>){
                        let arr = data["results"]! as? Array<AnyObject>
                        self.searchResult = arr!
                        print(arr![0]["name"]!)
                        self.parent?.performSegue(withIdentifier: "searchToResult", sender: nil)
                        SwiftSpinner.hide()
                    }
                    
                    
                    
                    // }
                    
                }
                
                
                
                
            }
        }
        
        
        
    }
    
    
    @IBAction func AutocompleteClicked(_ sender: Any) {
        print("click")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func autocompleteClicked(_ sender: UITextField) {
        print("click")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func removeErrorMsg(){
        if let label = parent?.view.viewWithTag(100) {
            print("Tag found")
            label.removeFromSuperview()
        }
    }
    @objc func conversion(data: Any)-> Dictionary<String, AnyObject>{
        let parsedResult : Dictionary<String, AnyObject>?
        do{
            parsedResult =  try JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as! Dictionary<String, AnyObject>
            return parsedResult!
        }catch{
            fatalError("conversion to dictionary failed")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewControllerSearch: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        from.text = "\(place.formattedAddress ?? "")"
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


