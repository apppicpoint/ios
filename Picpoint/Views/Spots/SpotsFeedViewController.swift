
//
//  SpotsFeedViewController.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import MapKit
import GoogleMaps
import GooglePlaces


class SpotsFeedViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var map: MapFeedViewController!
    
    @IBOutlet weak var spotsCollecionView: SpotsCollectionViewController!
    var spots = [Spot]()
    var currentLongitude: Double?
    var currentLatitude: Double?
    let locationManager = CLLocationManager()
    
    var tableDataSource: GMSAutocompleteTableDataSource?
    var srchDisplayController: UISearchController?
    var mapView = GMSMapView()
    var saveString = NSString()
    
    var lat = Double()
    var long = Double()

    
    @IBOutlet weak var changeMap: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configura los delegados del controlador de ubicaciones
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Configura los delegados de la tabla
        spotsCollecionView.delegate = self
        spotsCollecionView.dataSource = self
        
        map.tintColor = UIColor.init(red: 15, green: 188, blue: 249, alpha: 1)


        //spotsTableView.scroll(to: .top, animated: true) // Se actualiza la tabla al hacer scroll hacia arriba
        
        // Comprobacines de conectividad y ubicación
        if Connectivity.isLocationEnabled() && Connectivity.isConnectedToInternet(){
            //Obtiene las coordenadas actuales del usuario.
            currentLatitude = locationManager.location!.coordinate.latitude
            currentLongitude = locationManager.location!.coordinate.longitude
            
            //Obtiene la lista de spots
            getSpots()
            
            //Centra el mapa
            map.centerMap()
            
            map.showsCompass = false  // Hide built-in compass
            
            let compassButton = MKCompassButton(mapView: map)   // Make a new compass
            compassButton.compassVisibility = .visible          // Make it visible
            
            map.addSubview(compassButton) // Add it to the view
            
            // Position it as required
            
            compassButton.translatesAutoresizingMaskIntoConstraints = false
            compassButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -12).isActive = true
            compassButton.topAnchor.constraint(equalTo: map.topAnchor, constant: 12).isActive = true
        }
        
        changeMap.setImage(UIImage.init(imageLiteralResourceName: "mapa"), forSegmentAt: 0)
        //changeMap.setImage(UIImage.init(imageLiteralResourceName: "satelite"), forSegmentAt: 1)
        
        
        searchDisplayController?.searchBar.showsCancelButton = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.spotsCollecionView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func changeMap(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0) {
            
            self.map.mapType = MKMapType.standard
        }else {
            
            self.map.mapType = MKMapType.satellite
        }
    }
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        map.centerMap()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation() // Determina la ubicación actual del usuario
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (spots.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = SpotCollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotCell", for: indexPath) as! SpotCollectionViewCell
        cell.id = spots[indexPath.row].id
        cell.index = indexPath.row
        cell.titleTextField.text = spots[indexPath.row].name
        cell.distanceTextField.text = String(spots[indexPath.row].distance!) + "km from you"
        cell.spotImage?.layer.masksToBounds = true
        cell.spotImage?.contentMode = .scaleAspectFill
        cell.spotImage?.image = spots[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 75)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let visibleRect = CGRect(origin: spotsCollecionView.contentOffset, size: spotsCollecionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = spotsCollecionView.indexPathForItem(at: visiblePoint)
        
        if(indexPath != nil)
        {
            let cell = spotsCollecionView.cellForItem(at: indexPath!) as! SpotCollectionViewCell
            
            //print("************************* id loclizaciones")
            //print("*************************" , cell.id!)
            
            for pin in map.annotations
            {
                //print("bucle")
                
                if (pin is MKUserLocation)
                {
                    //print("MKUserLocation")
                    //print("-------------------------------------------")
                    continue
                }
                
                let pinSelected = pin as! PinAnnotation
                
                if(cell.id! == pinSelected.id!)
                {
                    //print(cell.id! , "celda", pinSelected.id! , "pin" , "true")
                    //print("-------------------------------------------")
                    
                    map.centerMapLocation(latitude: spots[cell.index!].latitude! , longitude: spots[cell.index!].longitude!)
                    resizePinImage(pin: pin, width: 40, height: 65, nameImage: "pin_full")
                }else
                {
                    //print(cell.id! , "celda", pinSelected.id! , "pin" , "false")
                    //print("-------------------------------------------")
                    resizePinImage(pin: pin, width: 15, height: 15, nameImage: "circle_point")
                }
            }
        }
    }
    
    func resizePinImage(pin:MKAnnotation,width:Int,height:Int,nameImage:String){
        
        let pinView = map.view(for: pin)
        pinView?.canShowCallout = true
        
        // Cambiar imagen de tamaño
        let pinImage = UIImage(named: nameImage)
        let size = CGSize(width: width, height: height) //proporcion 0.625
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        pinView?.image = resizedImage
        if(nameImage == "pin_full") {
            pinView?.centerOffset = CGPoint(x:0, y:((pinView?.image!.size.height)! / -2));
        }else {
            pinView?.centerOffset = CGPoint(x:0, y:0);
        }
        
        
    }
    
    func getSpots() {
        print("obteniendo spots")
        spots = [Spot]()
        let url = Constants.url+"distance"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        let parameters: Parameters = [
            "longitude":currentLongitude!,
            "latitude":currentLatitude!,
            "distance":150 // km
        ]
        Alamofire.request(url, method: .post,parameters: parameters, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                if(response.response?.statusCode == 200){
                    let jsonResponse = response.result.value as! [String:Any]
                    let data = jsonResponse["spots"] as! [[String: Any]]
                    for dataItem in data {
                        let distance = dataItem["distance_user"] as! Double
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        distance: Float(round(10*distance)/10),
                                        imageName: dataItem["image"] as! String
                                        )
                        self.spots.append(spot) //Por cada objeto en el json se añade un spot al array.
                        self.getSpotImage(imageName: spot.imageName!, spot: spot)
                        
                    }
                    
                    self.map.spots = self.spots // Le pasa los spots.
                    self.map.updateMap() //Actualiza los spots en el mapa
                    self.spotsCollecionView.reloadData()
                }
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
    
    func getSpotImage(imageName: String, spot: Spot){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                spot.image = data!
                self.spotsCollecionView.reloadData()
            case .failure(let error):
                print("Sin conexión en get spot image")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    
    //Prepara la clase de destino.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SpotDetailViewController {            
            let destination = segue.destination as! SpotDetailViewController
            let cell = sender as! SpotCollectionViewCell
            print(cell.id!)
            destination.spot = spots[cell.index!]
            
            
        }
    }
    
    //Necesario para unwind segue. Es para hacer dissmis de varias pantallas a la vez. No es necesario que tenga nada dentro.
    @IBAction func backFromNewSpotToFeed(_ segue: UIStoryboardSegue) {
        print("he volvido")
        getSpots()
    }
}


