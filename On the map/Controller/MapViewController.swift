//
//  MapViewController.swift
//  On_the_Map_AK_V1.3
//
//  Created by Andreas Kremling on 22.09.22.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
//Initialization of necessary array
//    var locations = [StudentInformation]()
    var markings = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//Set deleagte for mapView
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//Load known student locations and set pins
        getPinOfStudentLocations()
    }
    
    func getPinOfStudentLocations() {
//Remove current annotations and empty array
        self.mapView.removeAnnotations(self.markings)
        markings = []
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: nil, button: nil)
//go through know student locations and add to array
        for location in StudentsData.sharedInstance().students {
            markings.append(location.createMKPointAnnotation())
        }
//add markers to mapView
        mapView.addAnnotations(markings)
//En-/Disable UIElements
        loadingStatus(status: false, activityIndicator: activityIndicator, label: nil, button: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: nil, button: nil)
        Client.logout {
            DispatchQueue.main.async {
//Leave MapViewController
                self.dismiss(animated: true, completion: nil)
//En-/Disable UIElements
                loadingStatus(status: false, activityIndicator: self.activityIndicator, label: nil, button: nil)
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: nil, button: nil)
//Remove markings...
        mapView.removeAnnotations(mapView.annotations)
//And load them again
        getPinOfStudentLocations()
//En-/Disable UIElements
        loadingStatus(status: false, activityIndicator: self.activityIndicator, label: nil, button: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
//Change of Pin, just for fun...
        var pictureOfPin = UIImage(named: "icon_pin")
//Change size of pin-picture
        pictureOfPin = pictureOfPin?.resizeImageTo(size: CGSize(width: 50, height: 50))
        pinView!.image = pictureOfPin

        return pinView
    }
    
//Method to open link when label is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let url = URL(string: (view.annotation?.subtitle ?? "") ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
}

