//
//  otherProfileViewController.swift
//  Picpoint
//
//  Created by alumnos on 11/3/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class otherProfileViewController : UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userDescrp: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var titleNav: UINavigationItem!
    var user_id : Int!
    
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var pointsView: UIView!
    @IBOutlet weak var personalView: UIView!
    
    override func viewDidLoad() {
        getUserData()
        getFollowers()
        pointsView.isHidden = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeContainer(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            personalView.isHidden = false
            pointsView.isHidden = true
        case 1:
            personalView.isHidden = false
            pointsView.isHidden = true
        case 2:
            personalView.isHidden = true
            pointsView.isHidden = false
        default:
            break
        }
    }
    
    func getFollowers(){
        let url = Constants.url+"followersCount/"+String(self.user_id)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Int]
                self.followersCount.text = String(jsonResponse["followings"]!)
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
    
    func getUserData(){
        let url = Constants.url+"users/"+String(self.user_id)
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
                
                self.titleNav.title = data["nickName"] as! String
                self.userName.text = data["name"] as! String
                
                self.getUserImg(imageName: data["photo"] as! String)
                
                if let desc = data["biography"] as? String {
                    self.userDescrp.text = desc
                }
                else {
                    self.userDescrp.isHidden = true
                }
                
                
                
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
    
    func getUserImg(imageName : String){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
                self.userImage.clipsToBounds = true
                let data = response.result.value
                self.userImage.image = data!
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
