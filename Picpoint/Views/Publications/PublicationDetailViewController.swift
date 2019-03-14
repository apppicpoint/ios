//
//  PublicationDetailViewController.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class PublicationDetailViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var pointName: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var pubDescription: UILabel!
    @IBOutlet weak var pubImage: UIImageView!
    
    var publication_id : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPublications()
        isLiked()
    }

    @IBAction func reportBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Not available", message:
            "Functionality in development", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style:
            .cancel, handler: { (accion) in}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goSpot(_ sender: UIButton) {
        
        let displayVC : SpotDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PointDetail") as! SpotDetailViewController
        
        let navController = UINavigationController(rootViewController: displayVC)
        
        
        let url = Constants.url+"spots/"+String(sender.tag)
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
    
    @IBAction func goUser(_ sender: UIButton) {
        
        let displayVC : otherProfileViewController = UIStoryboard(name: "OtherProfile", bundle: nil).instantiateViewController(withIdentifier: "otherProfile") as! otherProfileViewController
        
        displayVC.user_id = sender.tag
        
        sendUserId(userID: sender.tag)
        
        self.present(displayVC, animated: true, completion: nil)
    }
    
    func sendUserId(userID : Int){
        otherProfilePersonalViewController.user_id = userID
    }
    
    func getPublications(){
        self.showSpinner(onView: self.view)
        let url = Constants.url+"publications/"+String(publication_id)
        let _headers : HTTPHeaders = [
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
                    let data = jsonResponse["publication"] as! [String: Any]
                    self.pubDescription.text = data["description"] as! String
                    
                    self.userName.tag = data["user_id"] as! Int
                    self.getPointImage(imageName: data["media"] as! String)
                    self.getUserData(user_id: data["user_id"] as! Int)
                        
                        if let spot_id = data["spot_id"] as? Int{
                            self.getSpotData(spot_id: spot_id)
                            self.pointName.tag = data["spot_id"] as! Int
                        }
                        else {
                            self.pointName.isHidden = true
                        }

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
    
    func getPointImage(imageName: String){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                self.pubImage.image = data!
            case .failure(let error):
                print(error,"error img point")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func getUserImage(imageName: String){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                self.userImage.image = data!
                self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
                self.userImage.clipsToBounds = true
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
    
    func getUserData(user_id: Int){
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
                self.userName.setTitle(data["name"] as! String, for: .normal)
                self.getUserImage(imageName: data["photo"] as! String)
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
    
    func getSpotData(spot_id: Int){
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
                self.pointName.setTitle(data["name"] as! String, for: .normal)
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
    
    func isLiked(){
        
        let url = Constants.url+"isLiked/"+String(self.publication_id)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Bool]
                
                if jsonResponse["is_liked"]! {
                    
                    self.likeBtn.setImage(UIImage(named: "hearttrue"), for: .normal)
                }
                else{
                    self.likeBtn.setImage(UIImage(named: "heartfalse"), for: .normal)
                }
                
            case .failure(let error):
                print(error,"error like")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func changeLikeFeed(_ sender: UIButton) {
        
        likePub()
        
        if likeBtn.currentImage == UIImage(named: "heartfalse"){
            likeBtn.setImage(UIImage(named: "hearttrue"), for: .normal)
        }
        else {
            likeBtn.setImage(UIImage(named: "heartfalse"), for: .normal)
        }
        
    }
    
    func likePub(){
        
        let url = Constants.url+"like"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        let parameters: Parameters = [
            "publication_id": self.publication_id
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:String]
                print(jsonResponse["message"]!)
            case .failure(let error):
                print(error,"error like dar")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
