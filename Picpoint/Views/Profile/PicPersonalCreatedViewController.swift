//
//  PicPersonalCreatedViewController.swift
//  Picpoint
//
//  Created by alumnos on 6/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation

import UIKit

import Alamofire

class PicPersonalCreatedViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
 
    @IBOutlet weak var picPersonalCollectionView: UICollectionView!
    var picsPersonal:[Publication] = []
    
    override func viewDidLoad() {
        picPersonalCollectionView.delegate = self
        picPersonalCollectionView.dataSource = self
        
        let flowLayout = picPersonalCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumLineSpacing = 5
        flowLayout?.minimumInteritemSpacing = 5
        
        getPublications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear , PicPersonalCreatedViewController")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picsPersonal.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picPersonalCell", for: indexPath) as! PicPersonalCell
        cell.picImage.image = picsPersonal[indexPath.row].image
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds: CGRect = UIScreen.main.bounds
        
        var width: CGFloat = bounds.size.width
        width = width - 30
        let dimension = width / 3

        return CGSize(width: dimension,height: dimension)
    }
    

    func getPublications(){
        self.showSpinner(onView: self.view)
        picsPersonal = [Publication]()
        let url = Constants.url+"publications"
        let _headers : HTTPHeaders = [
            "user_id ":UserDefaults.standard.string(forKey: "user_id")!,
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            self.removeSpinner()
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    let jsonResponse = response.result.value as! [String:Any]
                    let data = jsonResponse["publications"] as! [[String: Any]]
                    for dataItem in data {
                        let publication = Publication(id: dataItem["id"] as! Int,
                                                      description: dataItem["description"] as! String,
                                                      imageName: dataItem["media"] as! String,
                                                      user_id: dataItem["user_id"] as! Int,
                                                      tags: dataItem["tags"] as! [Tag]
                        )
                        
                        //Por cada objeto en el json se añade un spot al array.
                        self.getPointImage(imageName: publication.imageName!, publication: publication)
                        self.picsPersonal.append(publication)
                    }
                    
                    
                    self.picPersonalCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error,"error pics")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getPointImage(imageName: String, publication: Publication){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                publication.image = data!
            case .failure(let error):
                print(error,"error img")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
