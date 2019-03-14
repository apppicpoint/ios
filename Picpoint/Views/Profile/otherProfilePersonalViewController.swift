//
//  otherProfilePersonalViewController.swift
//  Picpoint
//
//  Created by alumnos on 12/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class otherProfilePersonalViewController : UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var gridPhotos: UICollectionView!
    public static var user_id : Int!
    var publications = [Publication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridPhotos.delegate = self
        gridPhotos.dataSource = self
        
        let flowLayout = gridPhotos.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .vertical
        flowLayout?.minimumLineSpacing = 2
        flowLayout?.minimumInteritemSpacing = 2
        
        getUserPicPersonal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personalPhotoCell", for: indexPath as IndexPath) as! otherPersonalCell
        
        cell.photoPub.image = publications[indexPath.row].image
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds: CGRect = UIScreen.main.bounds
        
        var width: CGFloat = bounds.size.width
        width = width - 4
        let dimension = width / 3
        
        if(self.publications.count > 3) {
            
            let heigth = Int(dimension) * Int(self.publications.count / 3)
            
            self.view.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: heigth)
            
        }else
        {
            self.view.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(dimension))
        }
        
        return CGSize(width: dimension,height: dimension)
    }

    
    func getUserPicPersonal(){
        
        self.showSpinner(onView: self.view)
        let url = Constants.url+"publications"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!,
            "user_id":String(otherProfilePersonalViewController.user_id)
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
                                                      tags: []
                        )
                        
                        self.getPubImage(imageName: publication.imageName!, publication: publication)
                        
                        self.publications.append(publication)

                    }
                    
                    self.gridPhotos.reloadData()
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
    
    func getPubImage(imageName: String, publication: Publication){
        let url = Constants.url+"imgLow/"+imageName
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                publication.image = data!
            case .failure(let error):
                print(error,"error img pub")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return publications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let displayVC : PublicationDetailViewController = UIStoryboard(name: "OtherProfile", bundle: nil).instantiateViewController(withIdentifier: "publicationDetail") as! PublicationDetailViewController
        
        displayVC.publication_id = publications[indexPath.row].id
        
        self.present(displayVC, animated: true, completion: nil)
        
    }
    
}

class otherPersonalCell: UICollectionViewCell  {
    
    @IBOutlet weak var photoPub: UIImageView!
}

