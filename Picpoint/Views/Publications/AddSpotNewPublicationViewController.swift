//
//  AddSpotNewPublicationViewController.swift
//  Picpoint
//
//  Created by alumnos on 26/2/19.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class AddSpotNewPublicationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    var spots = [Spot]()
    public static var pointSelected : Spot!
    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var nameSelected: UILabel!
    @IBOutlet weak var viewSelected: UIView!
    
    @IBOutlet weak var acceptBtn: UIBarButtonItem!
    
    func selectPin () {
        acceptBtn.isEnabled = true
        centerMap(latitude: AddSpotNewPublicationViewController.pointSelected.latitude!, longitude: AddSpotNewPublicationViewController.pointSelected.longitude!)
        setDetails(name: AddSpotNewPublicationViewController.pointSelected.name!, image: AddSpotNewPublicationViewController.pointSelected.image!)
        
        for pin in map.annotations
        {
            if (pin is MKUserLocation)
            {
                continue
            }
            
            let pinSelected = pin as! PinAnnotation
            
            if(AddSpotNewPublicationViewController.pointSelected.id! == pinSelected.id!){
                resizePinImage(pin: pin, width: 40, height: 65,map: map)
            }
        }
    }
    
    func resizePinImage(pin:MKAnnotation,width:Int,height:Int,map:MKMapView){
        
        let pinView = map.view(for: pin)
        
        // Cambiar imagen de tamaño
        let pinImage = UIImage(named: "pin_full")
        let size = CGSize(width: width, height: height) //proporcion 0.625
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        pinView?.image = resizedImage
        pinView?.centerOffset = CGPoint(x:0, y:((pinView?.image!.size.height)! / -2));
    }
    
    @IBAction func cancelPoint(_ sender: Any) {
        AddSpotNewPublicationViewController.pointSelected = nil
        backToDetail()
    }
    
    @IBAction func acceptPoint(_ sender: Any) {
        backToDetail()
    }
    
    func backToDetail(){
        NewPublicationViewController.pointSelected = AddSpotNewPublicationViewController.pointSelected
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSelected.isHidden = true
        map.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AddSpotNewPublicationViewController.pointSelected = NewPublicationViewController.pointSelected
        
        if AddSpotNewPublicationViewController.pointSelected == nil{
            centerMap(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        }
        
        getSpots()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if AddSpotNewPublicationViewController.pointSelected != nil{
            selectPin()
        }
    }
    
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        centerMap(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
    }
    
    func getSpots() {
        print("obteniendo spots")
        spots = [Spot]()
        let url = Constants.url+"spots"
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
                        self.spots.append(spot) //Por cada objeto en el json se añade un spot al array.
                        self.getSpotImage(imageName: spot.imageName!, spot: spot)
                    }

                    self.updateMap()
                    
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
    
    func setDetails(name: String, image: UIImage) {
        viewSelected.isHidden = false
        imgSelected.image = image
        nameSelected.text = name
    }
    
    func getSpotImage(imageName: String, spot: Spot){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                let data = response.result.value
                spot.image = data!
            case .failure(let error):
                print("Sin conexión en get spot image")
                print(error)
//                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
//                    "Check your connection and try it later", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "ok", style:
//                    .cancel, handler: { (accion) in}))
//                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    // Actualiza el mapa
    func updateMap() {
        print("Actualizando mapa")
        map.removeAnnotations(map.annotations) //Borra todas las anotaciones existentes para que no se repitan.
        for spot in spots {
            let coordinates = CLLocationCoordinate2DMake(spot.latitude!, spot.longitude!) // Establece las coordenadas del pin.
            let mark = PinAnnotation(pinTitle: spot.name, pinSubTitle: spot.desc, location: coordinates, id:spot.id!)// Crea el marcador
            map.addAnnotation(mark) // Añade el pin al mapa.
        }
    }
    
    // Centra el mapa
    func centerMap(latitude: Double, longitude: Double){
        let coordinates = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        map.setRegion(region, animated: true)
    }
    
    //Modifica el comportamiento de los pines
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("Creacion de pines")
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotation = annotation as! PinAnnotation
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.id!)) //Crea una vista personalizada del pin.
        
        annotationView.isEnabled = true // Activa el marcador.
        annotationView.canShowCallout = false // Establece si puede mostrar informacion extra en la burbuja
        annotationView.image = UIImage(named: "circle_point") // Establece la imagen del pin.
        annotationView.centerOffset = CGPoint(x:0, y:(annotationView.image!.size.height / -2));
        
        return annotationView
    }
    
    //Se llama al pulsar cada Pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        viewSelected.isHidden = false
        let annotation = view.annotation as! PinAnnotation
        changeStateAnn()
        let spotSelected = searchSpot(id: annotation.id!)
        
        centerMap(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        acceptBtn.isEnabled = true
        
        resizePinImage(pin: annotation, width: 40, height: 65,map: map)

        setDetails(name: spotSelected.name!, image: spotSelected.image!)
        
        AddSpotNewPublicationViewController.pointSelected = spotSelected
    
    }
    
    @IBAction func mapTap(_ sender: Any) {
        changeStateAnn()
        AddSpotNewPublicationViewController.pointSelected = nil
        viewSelected.isHidden = true
        acceptBtn.isEnabled = false
    }
    
    
    func searchSpot(id: Int) -> Spot{
        
        for spot in spots {
            if spot.id == id{
                return spot
            }
        }
        
        return spots[0]
    }
    
    func changeStateAnn(){
        
        for annotation in map.annotations{
            
            var annotationV = self.map.view(for: annotation)
            
            annotationV?.image = UIImage(named: "circle_point")
        }
    }
}
