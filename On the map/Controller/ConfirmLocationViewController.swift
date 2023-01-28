//
//  ConfirmLocationViewController.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 22.09.22.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmYourLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentInformation: StudentInformation?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupButtons(button: confirmYourLocationButton)
    }
    
    func getStudentLocation() {
        if let studentLocation = studentInformation {
            let studentLocation = Location(
                createdAt: studentLocation.createdAt ?? "",
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocation(location: studentLocation)
        }
    }
    func showLocation(location: Location) {
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: nil, button: confirmYourLocationButton)
        mapView.removeAnnotations(mapView.annotations)
        var coordinates: CLLocationCoordinate2D?
        coordinates = CLLocationCoordinate2DMake(location.latitude ?? 0.0, location.longitude ?? 0.0)
        
        if let coordinate = coordinates {
            let annotation = MKPointAnnotation()
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
        }
        loadingStatus(status: false, activityIndicator: activityIndicator, label: nil, button: confirmYourLocationButton)
    }
    
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: nil, button: confirmYourLocationButton)
        if let studentLocation = studentInformation {
//when there is no location existing for this student
            if Client.Auth.objectId == "" {
//add the location
                Client.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
//En-/Disable UIElements
                            loadingStatus(status: true, activityIndicator: self.activityIndicator, label: nil, button: self.confirmYourLocationButton)
//and leave the view
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
//In case of an error show an alert
                        DispatchQueue.main.async {
                            self.presentAlert(title: "Error", message: error?.localizedDescription ?? "")
//En-/Disable UIElements
                            loadingStatus(status: false, activityIndicator: self.activityIndicator, label: nil, button: self.confirmYourLocationButton)
                        }
                    }
                }
            }
//If there is a location for this student existing
            else {
//Inform user via alert that there is already a location stored for this user
                let alertVC = createAlert(title: "Update", message: "There is already a location specified for this student. Do you want to update the location?")
                alertVC.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction) in
//And update the location if user clicks "Update"
                    Client.refreshStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
//En-/Disable UIElements
                                loadingStatus(status: true, activityIndicator: self.activityIndicator, label: nil, button: self.confirmYourLocationButton)
//and leave the view
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
//In case of an error show an alert
                                self.presentAlert(title: "Error", message: error?.localizedDescription ?? "")
//En-/Disable UIElements
                                loadingStatus(status: false, activityIndicator: self.activityIndicator, label: nil, button: self.confirmYourLocationButton)
                            }
                        }
                    }
            }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        loadingStatus(status: false, activityIndicator: self.activityIndicator, label: nil, button: self.confirmYourLocationButton)
                    }
                }))
                self.present(alertVC, animated: true)
        }
    }
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

extension UIViewController {
    func createAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    return alert
    }
}
