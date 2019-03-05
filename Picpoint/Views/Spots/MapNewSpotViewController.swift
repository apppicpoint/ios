//
//  MapNewSpotViewController.swift
//  Picpoint
//
//  Created by David on 30/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class MapNewSpotViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    var spots = [Spot]()
    let locationManager = CLLocationManager()
    var longitude: Double?
    var latitude: Double?
    var currentLongitude: Double?
    var currentLatitude: Double?
    var spotNear: Bool?
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var changeMap: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Connectivity.isLocationEnabled() && Connectivity.isConnectedToInternet(){
            currentLatitude = locationManager.location!.coordinate.latitude
            currentLongitude = locationManager.location!.coordinate.longitude
            centerMap()
            setMapview()
            // Prepara el mapa y el manager para poder manejarlos.
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            map.delegate = self
            // Do any additional setup after loading the view.
            getSpots()
            map.tintColor = UIColor.init(red: 15, green: 188, blue: 249, alpha: 1)
        }
        
        changeMap.setImage(UIImage.init(imageLiteralResourceName: "mapa"), forSegmentAt: 0)
        changeMap.setImage(UIImage.init(imageLiteralResourceName: "satelite"), forSegmentAt: 1)
        goVertical()
    }
    
    func goVertical() {
        
        /*changeMap.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        for segment in changeMap.subviews {
            for segmentSubview in segment.subviews {
                if segmentSubview is UILabel {
                    (segmentSubview as! UILabel).transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
                }
            }
        }
        
        changeMap.translatesAutoresizingMaskIntoConstraints = false
        //let horizontalConstraint = NSLayoutConstraint(item: changeMap, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        //let verticalConstraint = NSLayoutConstraint(item: changeMap, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        changeMap.centerXAnchor.constraint(equalTo: self.map.leftAnchor).isActive = true
        changeMap.centerYAnchor.constraint(equalTo: self.map.centerYAnchor).isActive = true
        //let widthConstraint = NSLayoutConstraint(item: changeMap, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        //let heightConstraint = NSLayoutConstraint(item: changeMap, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        //NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])*/
    }
    
    @IBAction func changeMap(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0) {
            
            self.map.mapType = MKMapType.standard
        }else {
            
            self.map.mapType = MKMapType.satellite
        }
        
    }
    
    @IBAction func CurrentLocation(_ sender: UIButton) {
        pointInCurrentLocation()
    }
    
    @IBAction func backAct(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        centerMap()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation() // Determina la ubicación actual del usuario
    }
    
    func pointInCurrentLocation(){
    
        //Solo permite una anotación de nuevo spot a la vez
        for annotation in map.annotations {
            if annotation.title == "new" {
            map.removeAnnotation(annotation)
            }
        }

        //Guarda la longitud y latitud
        longitude = currentLongitude!
        latitude = currentLatitude!
        
        checkSpotNear(newSpotLongitude: longitude!, newSpotLatitude: latitude!, distance: 15)
    }

    // Centra el mapa
    func centerMap(){
        let coordinates = CLLocationCoordinate2D.init(latitude: currentLatitude!, longitude: currentLongitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
        
    }  
 
    // Actualiza el mapa
    func updateMap() {
        map.removeAnnotations(map.annotations) //Borra todas las anotaciones existentes para que no se repitan.
        for (index, spot) in spots.enumerated() {
            let coordinates = CLLocationCoordinate2DMake(spot.latitude!, spot.longitude!) // Establece las coordenadas del pin.
            let pin = PinAnnotation(pinTitle: spot.name, pinSubTitle: spot.desc, location: coordinates, id:index)           // Crea el marcador
            map.addAnnotation(pin) // Añade el pin al mapa.
        }

    }
    
    //Modifica el comportamiento de los pines
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotaion") //Crea una vista personalizada del pin.
        
        annotationView.isEnabled = true // Activa el marcador.
        annotationView.canShowCallout = true // Establece si puede mostrar informacion extra en la burbuja

        if annotation.title == "new" {
            annotationView.image = UIImage(named: "pin_blank") // Establece la imagen del pin.
            annotationView.centerOffset = CGPoint(x:0, y:(annotationView.image!.size.height / -2));

        } else {
            annotationView.image = UIImage(named: "circle_point") // Establece la imagen del pin.
            annotationView.centerOffset = CGPoint(x:0, y:0);

        }
        

        return annotationView
    }
    
    //Se llama al pulsar cada Pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // VACIO
        print("pulsado")
        
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Coge la referencia del storyboard
        //Declará el viewController al que se quiere acceder y abre sin necesidad de segue.
        //Es la mejor opción, ya que con segue se arrastraría el navigationController y el tabBarController.
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "app")
        self.present(newViewController, animated: false, completion: nil)
    }
    
    @IBAction func goToCamera(_ sender: UIBarButtonItem) {
        if(latitude == nil || longitude == nil || spotNear == nil){
            let alert = UIAlertController(title: "Select a valid location", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        } else if(spotNear == false){
            let alert = UIAlertController(title: "There is another point too close", message:
                "Select another location", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "camera", sender: sender)
        }
    }
    
    // Configura el reconocimiento de gestos en el mapa.
    func setMapview(){
        let pressed = UILongPressGestureRecognizer(target: self, action: #selector(MapNewSpotViewController.handleLongPress(gestureReconizer:))) // Establece el gesto de pulsación larga.
        pressed.minimumPressDuration = 0.5 // Tiempo de la pulsación larga.
        pressed.delaysTouchesBegan = true
        pressed.delegate = self
        self.map.addGestureRecognizer(pressed)
        
    }
    
    // Configuración de la pulsación larga.
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            //Solo permite una anotación de nuevo spot a la vez
            for annotation in map.annotations {
                if annotation.title == "new" {
                    map.removeAnnotation(annotation)
                }
            }
            let location = gestureReconizer.location(in: map)
            let coordinate = self.map.convert(location,toCoordinateFrom: map)
            
            //Guarda la longitud y latitud
            longitude = coordinate.longitude
            latitude = coordinate.latitude
            
            checkSpotNear(newSpotLongitude: longitude!, newSpotLatitude: latitude!, distance: 15)
        }
    }
    
    func getSpots() {
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
                        let spot = Spot(id: dataItem["id"] as! Int,
                                        name: dataItem["name"] as! String,
                                        desc: dataItem["description"] as? String,
                                        longitude: dataItem["longitude"] as! Double,
                                        latitude: dataItem["latitude"] as! Double,
                                        user_id: dataItem["user_id"] as! Int,
                                        distance: dataItem["distance_user"] as? Float,
                                        imageName: dataItem["image"] as? String)
                        self.spots.append(spot) //Por cada objeto en el json se añade una ubicación al array.
                        
                    }
                    self.updateMap() //Actualiza el mapa.

                }
                
            case .failure(let error):
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
    
    func checkSpotNear(newSpotLongitude: Double, newSpotLatitude: Double, distance: Double){
        let parameters: Parameters = [
            "distanceUser":0.0015,
            "longitude": longitude!,
            "latitude": latitude!,
        ]
        let url = Constants.url+"checkSpotNear"
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
                    
                    self.spotNear = (jsonResponse["spot"] as? Bool)!
                    
                    if(self.spotNear)!{
                        
                        // Add annotation:
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(newSpotLatitude, newSpotLongitude)
                        annotation.title = "new"
                        self.map.addAnnotation(annotation)
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Point to nearby", message: ("There's a point nearby. You have to be 15 meters away."), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: (jsonResponse["message"]! as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    print("error")
                }
            case .failure(let error):
                print("Sin conexión")
                print(error)
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CameraViewController {
            
            let destination = segue.destination as! CameraViewController
            destination.longitude = longitude
            destination.latitude = latitude
            destination.new = "spot"
        }
    }
}
