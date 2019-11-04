//
//  MapViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 7/9/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    public var placeName: String!
    public var scoreValue: Double!
    @IBOutlet weak var scoreLabel: UILabel!
    public var coordinate: Coordinate!
    public var currentLocatoin: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: -37.809605, longitude: 144.965168)
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        

        
        // lables' text
        placeNameLabel.text = placeName
        scoreLabel.text = String(format: " Score: %.2f", scoreValue)
        
    }

    @IBAction func backToPre(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    

}
extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLocatoin = locValue
        
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        mapView.centerCoordinate.latitude = coordinate.lat
        mapView.centerCoordinate.longitude = coordinate.lng
        
        // current location
        let currentAnnotation = MKPointAnnotation()
        currentAnnotation.coordinate = self.currentLocatoin
        currentAnnotation.title = "Your Location"
        let sourcePlacemark = MKPlacemark(coordinate: self.currentLocatoin, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        mapView.addAnnotation(currentAnnotation)
        
        
        // destination
        let annotation = MKPointAnnotation()
        //        annotation.coordinate = CLLocationCoordinate2D(latitude: -37.809605, longitude: 144.965168)
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lng)
        annotation.title = placeName
        let destinationPlacemark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // navigation
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}
