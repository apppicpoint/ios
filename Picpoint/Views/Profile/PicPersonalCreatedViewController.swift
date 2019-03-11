//
//  PicPersonalCreatedViewController.swift
//  Picpoint
//
//  Created by alumnos on 6/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation

import UIKit

class PicPersonalCreatedViewController: UIViewController {
    
    @IBOutlet weak var picPersonalCollectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear , PicPersonalCreatedViewController")
    }
}
