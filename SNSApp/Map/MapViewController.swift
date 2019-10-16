//
//  MapViewController.swift
//  SNSApp
//
//  Created by 吴欣 on 7/9/19.
//  Copyright © 2019 Kang Ning. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    public var placeName: String!
    public var coordinate: Coordinate!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.centerCoordinate.latitude = coordinate.lat
        mapView.centerCoordinate.longitude = coordinate.lng 
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: -37.809605, longitude: 144.965168)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        
        placeNameLabel.text = placeName
        
    }

    @IBAction func backToPre(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
