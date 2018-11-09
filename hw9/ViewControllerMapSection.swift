//
//  ViewControllerMapSection.swift
//  hw9
//
//  Created by 高家南 on 4/24/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

class ViewControllerMapSection: UIViewController {
    var viewPassed: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("there")
        if viewPassed == nil {
            print("view passed nil")
        }
        else{
            view = viewPassed
            print("finish")

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
