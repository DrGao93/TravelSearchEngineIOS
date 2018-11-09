//
//  row.swift
//  hw9
//
//  Created by 高家南 on 4/17/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit

class row {
    
    //MARK: Properties
    
    var icon: UIImage?
    var name: String?
    var address: String?
    var placeId: String?
    //MARK: Initialization
    
    init?(name: String, iconUrl: String, address: String,placeId: String) {
        
        // The name must not be empty
//        guard !name.isEmpty else {
//            return nil
//        }
//
        
        // Initialize stored properties.
        let imageUrl:URL = URL(string: iconUrl)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        let image = UIImage(data: imageData as Data)
        guard let jpg = image else{
            return nil
        }
        self.name = name
        self.icon = jpg
        self.address = address
        self.placeId = placeId
    }
}
