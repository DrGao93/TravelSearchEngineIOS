//
//  TableViewCellReview.swift
//  hw9
//
//  Created by 高家南 on 4/25/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

class TableViewCellReview: UITableViewCell {

    
    //@IBOutlet weak var profileImage: UIImageView!
   
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var time: UILabel!
    //@IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var reviewText: UITextView!
    var link:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        var url = URL(string: self.link!)
//        UIApplication.shared.open(url!)
        // Configure the view for the selected state
    }

}
