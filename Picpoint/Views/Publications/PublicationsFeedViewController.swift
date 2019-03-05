//
//  PublicationsFeedViewController.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import MapKit

class PublicationsFeedViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var publications = [Publication]()
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPublications()
    }
    
    
    func getPublications(){
        publications = [Publication]()
        let url = Constants.url+"publications"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
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
                        self.getUserData(publication: publication, user_id: publication.user_id!)
                        
                        if let spot_id = dataItem["spot_id"] as? Int{
                            publication.spot_id = spot_id
                            self.getSpotData(publication: publication, spot_id: publication.spot_id!)
                        }
                        else {
                            publication.spot_id = nil
                        }
                        
                        self.publications.append(publication)
                    }

                    
                    self.table.reloadData()
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
    
    func getUserData(publication: Publication, user_id: Int){
        let url = Constants.url+"users/"+String(user_id)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                let data = jsonResponse["user"] as! [String: Any]
                publication.userName = data["name"] as! String
                
            case .failure(let error):
                print(error,"error user")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func getSpotData(publication: Publication, spot_id: Int){
        let url = Constants.url+"spots/"+String(spot_id)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                let data = jsonResponse["spot"] as! [String: Any]
                publication.spotName = data["name"] as! String
            case .failure(let error):
                print(error,"error spot")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    //Número de secciones en cada fila de la tabla
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Número de filas de la tabla
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.publications.count
    }
    
    //Tamaño de la celda (alto)
    
    func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 465
    }
    
    //Generación de cada celda
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicationCell", for: indexPath) as! PublicationTableViewCell
        
        cell.publicationImage.image = publications[indexPath.row].image
        cell.descriptionPub.text = publications[indexPath.row].description
        cell.userName.text = publications[indexPath.row].userName
        cell.userImage.image = UIImage(named: "circle_point")
        
        if publications[indexPath.row].spot_id != nil {
            cell.pointName.titleLabel?.text = publications[indexPath.row].spotName
        }
        
        return cell
    }
    
}
