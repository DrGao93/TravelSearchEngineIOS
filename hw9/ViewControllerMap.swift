//
//  ViewControllerMap.swift
//  hw9
//
//  Created by 高家南 on 4/24/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

class ViewControllerMap: UIViewController, GMSMapViewDelegate{
    
    @IBOutlet weak var from: UITextField!
    var viewToPass : UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var googleMap: GMSMapView!
    var destLat:Double?
    var destLon:Double?
    var origLat:Double?
    var origLon:Double?
    var mode:String? = "driving"
    var polyline: GMSPolyline?
    var origMarker:GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude:  destLat!, longitude: destLon!, zoom: 11.0)
        let position = CLLocationCoordinate2D(latitude: destLat!, longitude: destLon!)
        let marker = GMSMarker(position: position)
        marker.map = self.googleMap
        self.googleMap.camera = camera
        self.googleMap.delegate = self
        self.googleMap.settings.zoomGestures = true
        
        
    }
    
    @IBAction func autocompleteClicked(_ sender: Any) {
        print("clicked")
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    
    
    func drawPath()
    {
        if self.origMarker != nil {
            self.origMarker!.map = nil
        }
        
        let position = CLLocationCoordinate2D(latitude: origLat!, longitude: origLon!)
        self.origMarker = GMSMarker(position: position)
        self.origMarker!.map = self.googleMap
        
        if self.polyline != nil {
            self.polyline!.map = nil
        }
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origLat!),\(origLon!)&destination=\(destLat!),\(destLon!)&mode=\(self.mode!)"
        print(url)
        Alamofire.request(url).responseJSON { response in

            print("data")


            do{
                 let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                //print(routes)
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    self.polyline = GMSPolyline.init(path: path)
//                    print("points:\(points)")
//                    print("path:\(path)")
//                    print("polyline:\(polyline)")
                    
                    self.polyline!.strokeWidth = 4
                    self.polyline!.strokeColor = UIColor.blue
                    self.polyline!.map = self.googleMap
                    
                    
                    
                    
                }
            }catch{
                print("error handling json")
            }
            
            

            // print route using Polyline
            

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.mode = "driving"
            print("o selected")
            drawPath()
        }
        else if segment.selectedSegmentIndex == 1{
            self.mode = "bicycling"
            print("1 selected")
            drawPath()
        }
        else if segment.selectedSegmentIndex == 2{
            self.mode = "transit"
            print("2 selected")
            drawPath()
        }
        else if segment.selectedSegmentIndex == 3{
            self.mode = "walking"
            print("3 selected")
            drawPath()
        }

    }
    

    

}

extension ViewControllerMap: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        
        from.text = place.formattedAddress
        origLat = place.coordinate.latitude
        origLon = place.coordinate.longitude
        print("origLat")
        print(origLat)
        
        drawPath()
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
