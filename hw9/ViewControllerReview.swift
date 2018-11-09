//
//  ViewControllerReview.swift
//  hw9
//
//  Created by 高家南 on 4/25/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit



//class review{
//    var author_name
//}
struct detailsResult: Decodable{
    let reviews: [review]
    enum CodingKeys : String, CodingKey {
        
        case reviews = "reviews"
    }
}

struct review: Decodable{
    let author_name: String
    let profile_photo_url: String
    let rating: Int
    let text: String
    let time: Int
    let author_url: String
    
}
class ViewControllerReview: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var sortBy: UISegmentedControl!
    
    @IBOutlet weak var segControllerOrder: UISegmentedControl!
    
    @IBOutlet weak var reviewsChange: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    //var googleReviews:Array<AnyObject>?
    var yelpReviews:Array<review>?
    var googleTempReviews:Array<review>?
    var googleReviews : Array<review>?
    var reviewTo: Array<review>?
    override func viewDidLoad() {
        super.viewDidLoad()
        googleTempReviews = googleReviews
        reviewTo = googleReviews
        //print(reviewsFake)
                // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return googleReviews!.count
        print("rows in section called")
        if googleReviews != nil {
            return googleReviews!.count
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: reviewTo![indexPath.row].author_url)
             UIApplication.shared.open(url!)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("celling")
        let cellIdentifier = "reviewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCellReview else{
            fatalError("The dequeued cell is not an instance of TableViewCellReview.")
        }
        var profileView = UIImageView()
        let imageUrl:URL = URL(string: reviewTo![indexPath.row].profile_photo_url as! String)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        let image = UIImage(data: imageData as Data)
        profileView.image = image
        cell.profileImage.image = image
        cell.name.text = reviewTo![indexPath.row].author_name
        
        let date = Date(timeIntervalSince1970: Double(reviewTo![indexPath.row].time) )
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        cell.time.text = strDate
        var rating = CosmosView()
        rating.rating = Double(reviewTo![indexPath.row].rating)
        //print("rating\(rating.rating)")
        cell.rating.rating = Double(reviewTo![indexPath.row].rating)
//        var textView = UITextView()
//        textView.text = reviewTo![indexPath.row]["text"] as! String
        cell.reviewText.text = reviewTo![indexPath.row].text as! String
        cell.link = reviewTo![indexPath.row].author_url
//        var profileView = UIImageView()
//
//        cell.profileImage = profileView
//        cell.name.text = "abc"
//        cell.time.text = "time"
//        cell.rating.rating = 2
//        cell.reviewText = UITextView()
        
        //print(row.name!)
        // Configure the cell... fill in image name and address!
        
        return cell
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func reviewsFrom(_ sender: Any) {
        if reviewsChange.selectedSegmentIndex == 1{
            print("11111111")
            reviewTo = googleReviews
            tableView.removeFromSuperview()
            tableView.reloadData()
        }
    }
    
    @IBAction func sortBY(_ sender: Any) {
        if sortBy.selectedSegmentIndex == 0 {
            reviewTo = googleTempReviews
            tableView.reloadData()
        }
        if sortBy.selectedSegmentIndex == 1 {
            print("sortby = rating")
            if segControllerOrder.selectedSegmentIndex == 0{
                reviewTo?.sort(by: {
                    $0.rating < $1.rating
                })
                //print(googleReviews)
                tableView.reloadData()
            }else{
                reviewTo?.sort(by: {
                    $0.rating > $1.rating
                })
                //print(googleReviews)
                tableView.reloadData()
            }
            
        }
    
        if sortBy.selectedSegmentIndex == 2 {
            print("sort by date")
            if segControllerOrder.selectedSegmentIndex == 0{
                reviewTo?.sort(by: {
                    $0.time < $1.time
                })
                //print(googleReviews)
                tableView.reloadData()
            }else{
                reviewTo?.sort(by: {
                    $0.time > $1.time
                })
                //print(googleReviews)
                tableView.reloadData()
            }
        
    }
    }
    
    @IBAction func orderChange(_ sender: Any) {
        print("order change")
        reviewTo?.reverse()
        tableView.reloadData()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
