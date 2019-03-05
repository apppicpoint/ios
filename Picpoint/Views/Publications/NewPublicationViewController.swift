//
//  NewPublicationViewController.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewPublicationViewController: UIViewController, UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var image: UIImage?
    var imageName: String?
    public static var tagsId:[Tag] = [Tag]()
    public static var clase: NewPublicationViewController?
    
    public static var pointSelected: Spot?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var personalRadioBtn: UIButton!
    @IBOutlet weak var portfolioRadiobtn: UIButton!
    @IBOutlet weak var addTagsBtn: UIButton!
    
    @IBOutlet weak var namePoint: UILabel!
    @IBOutlet weak var addressPoint: UILabel!
    
    
    let utils = Utils()
    
    @IBAction func tagsBtn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert : TagsViewController = storyboard.instantiateViewController(withIdentifier: "tagPopUp") as! TagsViewController
        myAlert.new = "pub"
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    @IBAction func touchRadioBtn(_ sender: UIButton) {
        
        sender.setImage(UIImage(named: "radiobuttontrue"), for: UIControlState.normal)
        
        if sender.titleLabel?.text == "personal"{
            
            portfolioRadiobtn.setImage(UIImage(named: "radiobuttonfalse"), for: UIControlState.normal)
        }
        else {
            personalRadioBtn.setImage(UIImage(named: "radiobuttonfalse"), for: UIControlState.normal)
        }
    }
    
    func checkTagsState() {
        
        if NewPublicationViewController.tagsId.count > 0 {
            tagCollectionView.isHidden = false
        }
        else {
            tagCollectionView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        NewPublicationViewController.clase = self
        self.titleTextField.delegate = self
        
        
        self.hideKeyboardWhenTappedAround()
        
        titleTextField.greyDesign()
        
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self
        
        let flowLayout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        flowLayout?.scrollDirection = .horizontal
        flowLayout?.minimumLineSpacing = 3
        flowLayout?.minimumInteritemSpacing = 3
        //flowLayout?.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if NewPublicationViewController.pointSelected != nil {
            namePoint.text = NewPublicationViewController.pointSelected?.name
            addressPoint.text = NewPublicationViewController.pointSelected?.desc
        }
        else {
            namePoint.text = "Point name"
            addressPoint.text = "Address"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        checkTagsState()
        return NewPublicationViewController.tagsId.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = SpotTagCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCellDetaill", for: indexPath) as! SpotTagCollectionViewCell
        cell.TagName.text = NewPublicationViewController.tagsId[indexPath.row].name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let letras = NewPublicationViewController.tagsId[indexPath.row].name?.count
        
        //print(tags[indexPath.row].name!)
        //print(letras!)
        //print("---------------------------------------")
        
        let dimensions = CGFloat((8 * letras!) + 20)
        return CGSize(width: dimensions,height: 40)
    }
    
    func storeLocation() {
        
        var sendid:[Int] = [Int]()
        
        for tag in NewPublicationViewController.tagsId {
            
            sendid.append(tag.id!)
        }
        
        
        let parameters: Parameters = [
            "description":titleTextField.text ?? "",
            "media":imageName!,
            "tag_id": sendid,
            "spot_id": NewPublicationViewController.pointSelected?.id ?? nil
        ]
        let url = Constants.url+"publications"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
            
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                if(response.response?.statusCode == 200){
                    print("Pic subido")
                    print(jsonResponse["message"]!)
                    
                    let alert = UIAlertController(title: "OK", message: "Pic created", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: .cancel, handler: { (accion) in self.performSegue(withIdentifier: "unwindToFeed", sender: nil) }))
                    self.present(alert, animated: true)
                    return
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: (jsonResponse["message"]! as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    print("error")
                }
            case .failure(let error):
                
                print(error)
                
                let alert = UIAlertController(title: "Ups! Something was wrong", message:
                    "Pls, try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style:
                    .default, handler: { (accion) in
                        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "ok :(", style:
                    .cancel, handler: { (accion) in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func uploadPhotoRequest(){
        let image = self.image
        let imgData = UIImageJPEGRepresentation(image!, 1)
        let url = Constants.url+"img"
        print(url)
        let headers: HTTPHeaders = [
            "Authorization":UserDefaults.standard.string(forKey: "token")!,
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imgData!, withName: "img", fileName: self.imageName!+".png", mimeType: "image/png")
            
            print(self.imageName!+".png")
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    if(response.response?.statusCode == 200){
                        print("Foto subida")
                        self.storeLocation()
                        return
                    }
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Ups! Something was wrong", message:
                    "Pls, try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style:
                    .default, handler: { (accion) in
                        UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "Accept", style:
                    .cancel, handler: { (accion) in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // Valida los datos.
    func validateInputs() -> Bool
    {
        if ((titleTextField.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There cannot be empty fields", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        if titleTextField.text!.count < 4 || titleTextField.text!.count > 30 {
            let alert = UIAlertController(title: "Invalid inputs", message:
                "Title size must be between 4 and 30 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    @IBAction func createBtn(_ sender: UIButton) {
        if  validateInputs() && Connectivity.isLocationEnabled() && Connectivity.isConnectedToInternet(){
            self.uploadPhotoRequest()
        }
    }
    
    //Esta función se encarga de ocultar el teclado
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

