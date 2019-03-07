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
        pics.append(Publication(id: 1, description: "Holaaaaaaa", imageName: "Imagen", user_id: 2, tags: [Tag.init(id: 2, name: "Fiezzta")]))
        print(pics.count)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! PicsCollectionViewCell
        cell.picImage = pics[indexPath.row].image
        
        return cell
    }
    
    /*func getPics(){
        let url = Constants.url+"spotPublications"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: _headers){
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                let data = jsonResponse["user"] as! [String: Any]
                /*self.pics.append(Publication(id: jsonResponse["id"] as! [String: Int],
                                        description: jsonResponse["description"] as! [String: String],
                                        imageName: jsonResponse["media"] as! [String: UIImage],
                                        user_id: jsonResponse["user_id"] as! [String: Int],
                                        tags: ))*/
                
                break
                
            case .failure(let error):
                break
                
            }
        }*/
    
    }

 