//
//  ViewControllerPhotos.swift
//  hw9
//
//  Created by 高家南 on 4/23/18.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewControllerPhotos: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var placeId: String?
    var images : [UIImage] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
        print(images.count)
    print(placeId!)
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("reuseing")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCell
        cell.photo.image = images[indexPath.row]
        print(cell.photo.image)
        return cell
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
