//
//  favRows.swift
//  hw9
//
//  Created by 高家南 on 4/21/18.
//  Copyright © 2018 me. All rights reserved.
//

import Foundation
import UIKit
import os.log

class FavRow : NSObject, NSCoding{
    
    //MARK: Properties
    
    var icon: UIImage?
    var name: String?
    var address: String?
    
    //MARK: Initialization
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("rows")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let icon = "icon"
        static let address = "address"
    }
    
    
    init?(name: String, icon: UIImage, address: String) {

        self.name = name
        self.icon = icon
        self.address = address
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(icon, forKey: PropertyKey.icon)
        aCoder.encode(address, forKey: PropertyKey.address)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a row object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let icon = aDecoder.decodeObject(forKey: PropertyKey.icon) as? UIImage
        
        let address = aDecoder.decodeObject(forKey: PropertyKey.address) as? String
        
        // Must call designated initializer.
        self.init(name: name, icon: icon!, address: address!)
        
    }

}
