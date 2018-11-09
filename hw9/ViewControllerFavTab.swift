//
//  ViewControllerFavTab.swift
//  hw9
//
//  Created by 高家南 on 4/21/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

class ViewControllerFavTab: UIViewController {

    @IBOutlet weak var FavView: UIView!
    @IBOutlet weak var NoFavView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rows = loadRows()
        if rows!.count == 0{
            self.FavView.alpha = 0
            self.NoFavView.alpha = 1
        }else{
            self.FavView.alpha = 1
            self.NoFavView.alpha = 0
       }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func loadRows() -> [FavRow]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FavRow.ArchiveURL.path) as? [FavRow]
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
