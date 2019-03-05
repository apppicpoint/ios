//
//  PicsCollectionViewController.swift
//  Picpoint
//
//  Created by alumnos on 5/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PicsCollectionViewController: UICollectionViewController {
    var pics = [Publication]()
    
    override func viewDidLoad() {
        <#code#>
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! PicsCollectionViewCell
    }
    
    func getPics(){
        let url = Constants.url+""
        Alamofire.request(url, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
    
    }
}
