//
//  AddLocationViewController.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 22.09.22.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var searchLocationButton: UIButton!
    
    var locationTextFieldEmpty = true
    var websiteTextFieldEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        websiteTextField.delegate = self
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//Setup Textfields and buttons
        setupTextFields(textfield: locationTextField)
        setupTextFields(textfield: websiteTextField)
        setupButtons(button: searchLocationButton)
//Set values for variables
        locationTextFieldEmpty = true
        websiteTextFieldEmpty = true
//En-/Disable UIElements
        loadingLabel.isHidden = true
        searchLocationButton.isEnabled = false
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
//Method for tapping cancel button
    @IBAction func cancelButtonTapped(_ sender: Any) {
//Leave current view
        self.dismiss(animated: true, completion: nil)
    }
    
//Method for tapping searchLocation button
    @IBAction func searchLocationButtonTapped(_ sender: Any) {
//En-/Disable UIElements
        loadingStatus(status: true, activityIndicator: activityIndicator, label: loadingLabel, button: searchLocationButton)
        let newLocation = locationTextField.text ?? ""
//Check if inserted website is valid
        guard let url = URL(string: self.websiteTextField.text ?? ""),
                UIApplication.shared.canOpenURL(url) else {
            self.presentAlert(title: "Invalid Website", message: "Maybe you missded 'https://' at the beginning of your link?")
//En-/Disable UIElements
            loadingStatus(status: false, activityIndicator: activityIndicator, label: loadingLabel, button: searchLocationButton)
            return
        }
//Search for Location
        geocodeLocation(newLocation: newLocation)
    }
    
//Method to find inserted location
    func geocodeLocation(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) {(newMark, error) in
//Show an error-alert if location is not found
            if let error = error{
                self.presentAlert(title: "Location not found", message: error.localizedDescription)
//En-/Disable UIElements
                loadingStatus(status: false, activityIndicator: self.activityIndicator, label: self.loadingLabel, button: self.searchLocationButton)
            } else {
//If location is found
                var location: CLLocation?
                if let mark = newMark, mark.count > 0 {
                    location = mark.first?.location
                }
//...show location on next VC
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
//...and save information in variable
                controller.studentInformation = self.completeStudentInformation(location?.coordinate ?? CLLocationCoordinate2DMake(0.0, 0.0))
                self.navigationController?.pushViewController(controller, animated: true)
            }
                
        }
        
    }
    
    func completeStudentInformation(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        let studentInformation = [
            "firstName": Client.Auth.firstName,
            "lastName": Client.Auth.lastName,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "uniqueKey": Client.Auth.key,
            ] as [String: AnyObject]

    return StudentInformation(studentInformation)

}
        
    
//Enable Button dependent on textfield-entry
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//check which Textfield
                    if textField == locationTextField {
                        let text = locationTextField.text ?? ""
                        guard let textRange = Range(range, in: text) else { return false }
                        let updatedText = text.replacingCharacters(in: textRange, with: string)
//check if anything was entered and set status of variables
                        if updatedText.isEmpty && updatedText == "" {
                            locationTextFieldEmpty = true
                        } else {
                            locationTextFieldEmpty = false
                        }
                    }
//check which Textfield
                    if textField == websiteTextField {
                        let text = websiteTextField.text ?? ""
                        guard let textRange = Range(range, in: text) else { return false }
                        let updatedText = text.replacingCharacters(in: textRange, with: string)
//check if anything was entered and set status of variables
                        if updatedText.isEmpty && updatedText == "" {
                            websiteTextFieldEmpty = true
                        } else {
                            websiteTextFieldEmpty = false
                        }
                    }
//Enable Button dependent on Textfield-input
                    if locationTextFieldEmpty == false && websiteTextFieldEmpty == false {
                        searchLocationButton.isEnabled = true
                    } else {
                        searchLocationButton.isEnabled = false
                    }
                    
                    return true
                    
                }
}
