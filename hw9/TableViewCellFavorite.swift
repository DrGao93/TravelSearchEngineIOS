//
//  TableViewCellFavorite.swift
//  hw9
//
//  Created by 高家南 on 4/21/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

class TableViewCellFavorite: UITableViewCell {
    
    
    @IBOutlet weak var FavName: UILabel!
    @IBOutlet weak var FavAddress: UILabel!
    @IBOutlet weak var FavIcon: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
