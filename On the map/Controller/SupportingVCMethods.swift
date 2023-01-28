//
//  SupportingVCMethods.swift
//  On the map
//  Udacity Nanodegree Project
//  Created by Andreas Kremling on 22.09.22.
//

import Foundation
import UIKit

extension UIViewController {
    
//Method to present an Alert
    func presentAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertViewController, animated: true)
    }
    
//Method to setup textfields
    func setupTextFields(textfield: UITextField) {
        textfield.text = ""
        textfield.layer.cornerRadius = 5
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.gray.cgColor
    }

//Method to setup buttons
    func setupButtons(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
    }
}

//set status of ActivityIndicator, Buttons and Label dependent on login-status
func loadingStatus(status: Bool, activityIndicator: UIActivityIndicatorView?, label: UILabel?, button: UIButton?) {
    if status == true {
        DispatchQueue.main.async {
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
            label?.isHidden = false
            button?.isEnabled = false
        }
    } else {
        DispatchQueue.main.async {
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            label?.isHidden = true
            button?.isEnabled = true
        }
    }
}

func verifyURL(url: URL?) -> Bool {
        if let url = url {
                return UIApplication.shared.canOpenURL(url)
        }
    return false
}

extension UIImage {
//method to resize UIImage
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

