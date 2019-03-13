//
//  otherSpotsCreated.swift
//  Picpoint
//
//  Created by alumnos on 13/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class otherSpotsCreatedViewController : UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var poinsTable: UITableView!
    public static var user_id : Int!
    var points = [Spot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        poinsTable.delegate = self
        poinsTable.dataSource = self
        
        getUserPointsPersonal()
    }
    
    func getUserPointsPersonal(){
        let url = Constants.url+"spots"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!,
            "user_id":String(otherProfilePersonalViewController.user_id)
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    let jsonResponse = response.result.value as! [String:Any]
                    let data = jsonResponse["spots"] as! [[String: Any]]
                    for dataItem in data {
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        distance: 0,
                                        imageName: dataItem["image"] as! String
                        )
                        
                        self.getPointImage(imageName: spot.imageName!, point: spot)
                        
                        self.points.append(spot)
                        
                    }
                    
                    print(self.points)
                    
                    self.poinsTable.reloadData()
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
    
    func getPointImage(imageName: String, point: Spot){
        let url = Constants.url+"imgLow/"+imageName
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                point.image = data!
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
    
    //Número de secciones en cada fila de la tabla
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Número de filas de la tabla
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.points.count
    }
    
    //Tamaño de la celda (alto)
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 88
    }
    
    //Generación de cada celda
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "otherSpotsCreatedCell", for: indexPath) as! otherSpotsCreatedCell
        
        cell.pointImg.image = points[indexPath.row].image
        cell.pointName.text = points[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let displayVC : SpotDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PointDetail") as! SpotDetailViewController
        
        let navController = UINavigationController(rootViewController: displayVC)
        
        
        let url = Constants.url+"spots/"+String(points[indexPath.row].id!)
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
                    let data = jsonResponse["spot"] as! [String: Any]
                    let spot = Spot(id: data["id"] as! Int,
                                    name: data["name"] as! String,
                                    desc: data["description"] as? String,
                                    longitude: data["longitude"] as! Double,
                                    latitude: data["latitude"] as! Double,
                                    user_id: data["user_id"] as! Int,
                                    distance: 0,
                                    imageName: data["image"] as! String
                    )
                    
                    displayVC.spot = spot
                    displayVC.navBar = 1
                    
                }
                
                self.present(navController, animated:true, completion: nil)
                
            //Si falla la conexión se muestra un alert.
            case .failure(let error):
                print("Sin conexión en get spot")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

class otherSpotsCreatedCell : UITableViewCell{
    
    @IBOutlet weak var pointName: UILabel!
    @IBOutlet weak var pointImg: UIImageView!
    
}
