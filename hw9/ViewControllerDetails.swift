//
//  ViewControllerDetails.swift
//  hw9
//
//  Created by 高家南 on 4/22/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import MessageUI

class ViewControllerDetails: UIViewController {
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("pressed~~~~~~~~!!!!!!!!!")
    }
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var googlePageLabel: UILabel!
    
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phoneNumber: UITextView!
    
    
    @IBOutlet weak var priceLevel: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var rating: CosmosView!
    var call:UITextView?
    var json: Dictionary<String, AnyObject>?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("detail load")
        //self.navigationItem.title = "shitt"
        print(self.navigationItem.title)
        address.text = json!["result"]!["formatted_address"] as! String
        if  let phoneNumberString = json!["result"]!["international_phone_number"] as? String{
            phoneNumber.text = phoneNumberString
        }else{
            phoneNumber.text = "No information"
            
        }
        
        if  let priceLevelInt = json!["result"]!["price_level"] as? Int{
            var toWrite:String = ""
            for _ in 1...priceLevelInt{
                toWrite += "$"
            }
            
            priceLevel.text = toWrite
        }else{
            priceLevel.text = "No information"
        }
        
        if  let websiteString = json!["result"]!["website"] as? String{
                websiteButton.setTitle(websiteString, for: .normal)
            
        }else{
            websiteButton.setTitle("No information", for: .normal)
        }
        if  let pageString = json!["result"]!["url"] as? String{
            
            pageButton.setTitle(pageString, for: .normal)

        }else{
            pageButton.setTitle("No information", for: .normal)
        }
        if  let rate = json!["result"]!["rating"] as? Double{
            print(rate)
            rating.rating = rate
            
        }else{
            rating.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func webButtonPressed(_ sender: Any) {
        print("tapped")
        var url = URL(string: websiteButton.title(for: .normal)!)
        UIApplication.shared.open(url!)
    }
    @IBAction func pageButtonPressed(_ sender: Any) {
        print("tapped")
        var url = URL(string: pageButton.title(for: .normal)!)
        UIApplication.shared.open(url!)
    }
//    @IBAction func numberPressed(_ sender: Any) {
//        print("num pressed")
////        let controller = MFMessageComposeViewController()
////        controller.body = "Message Body"
////        controller.recipients = ["2179796312"]
////        controller.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
////        self.present(controller, animated: true, completion: nil)
//        
////        guard let num = phoneNumber.titleLabel?.text
////        else{
////            print("null")
////        }
//        if phoneNumber.titleLabel?.text! == nil{
//            print("Null")
//        }else{
//            UIApplication.shared.open(URL(string: "sms://+12179796312")!, options: [:], completionHandler: nil)
//        }
//        //UIApplication.shared.open(URL(string: "sms://2179796312")!, options: [:], completionHandler: nil)
////        if let url = URL(string: "sms://\(phoneNumber.titleLabel?.text!)") {
////            UIApplication.shared.open(url)
////        }
////        if let phoneString = phoneNumber.titleLabel?.text!{
////            phoneString.makeAColl()
////        }
//
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


extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
