//
//  MapTableViewCell.swift
//  Picpoint
//
//  Created by David on 01/02/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit
import MapKit

class MapFeedViewController: MKMapView , CLLocationManagerDelegate, MKMapViewDelegate {
    
    var spots = [Spot]()
    var currentLongitude: Double?
    var currentLatitude: Double?
    let locationManager = CLLocationManager()
    
    //@IBOutlet weak var map: MKMapView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        
    }
    
    
    @IBAction func centerMapBtn(_ sender: UIButton) {
        centerMap()
    }
    
    func centerMapLocation(latitude:Double,longitude:Double) {
        let coordinates = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.setRegion(region, animated: true)
    }
    // Centra el mapa
    func centerMap(){
        let coordinates = CLLocationCoordinate2D.init(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        self.setRegion(region, animated: true)
    }
    
    // Actualiza el mapa
    func updateMap() {
        print("Actualizando mapa")
        self.removeAnnotations(self.annotations) //Borra todas las anotaciones existentes para que no se repitan.
        for spot in spots {
            let coordinates = CLLocationCoordinate2DMake(spot.latitude!, spot.longitude!) // Establece las coordenadas del pin.
            let mark = PinAnnotation(pinTitle: spot.name, pinSubTitle: spot.desc, location: coordinates, id:spot.id!)           // Crea el marcador
            self.addAnnotation(mark) // Añade el pin al mapa.
        }
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
        annotationView.canShowCallout = true // Establece si puede mostrar informacion extra en la burbuja
        annotationView.image = UIImage(named: "circle_point") // Establece la imagen del pin.
        annotationView.centerOffset = CGPoint(x:0, y:0);
        
        //Crea un botón derecho en la burbuja personalizado.
        let calloutRightImage = UIImage(named: "pin_full")
        let calloutRightButton = UIButton(type: .custom)
        calloutRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        calloutRightButton.setImage(calloutRightImage, for: .normal)
        annotationView.rightCalloutAccessoryView = calloutRightButton
        
        configureDetailView(annotationView: annotationView)

        return annotationView
    }
    
    //Se llama al pulsar cada Pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // VACIO
        print("pulsado")

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
      
        if(self.spots.count > 0) {
            
            let id = self.spots[0].id
            
            for pin in mapView.annotations
            {
                if (pin is MKUserLocation)
                {
                    continue
                }
                let pinSelected = pin as! PinAnnotation
                
                if(id! == pinSelected.id!){
                    resizePinImage(pin: pin, width: 40, height: 65,map: mapView)
                }
            }
        }
    }
    
    func resizePinImage(pin:MKAnnotation,width:Int,height:Int,map:MKMapView){
        
        let pinView = map.view(for: pin)
        pinView?.canShowCallout = true
        
        // Cambiar imagen de tamaño
        let pinImage = UIImage(named: "pin_full")
        let size = CGSize(width: width, height: height) //proporcion 0.625
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        pinView?.image = resizedImage
        pinView?.centerOffset = CGPoint(x:0, y:((pinView?.image!.size.height)! / -2));
    }
    
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 60
        let height = 30
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.tintColor = .red

        annotationView.detailCalloutAccessoryView = view
    }
    
}
