//
//  TableViewController.swift
//  On_the_Map_AK_V1.3
//
//  Created by Andreas Kremling on 22.09.22.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var studentTableView: UITableView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    //Initialisation of activityIndicator
        func activityIndicatorInit() {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            activityIndicator.center = self.view.center
            self.view.addSubview(activityIndicator)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getListOfStudentLocations()
    }
    
//Method to load student locations
    func getListOfStudentLocations() {
//Setup activityIndicator
        activityIndicatorInit()
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = .white
//Load locations
        Client.loadStudentLocations { students, error in
            DispatchQueue.main.async {
//Reload data of tableView
                self.studentTableView.reloadData()
            }
        }
//Stop and hide activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
//Method for tapping logout button
    @IBAction func logoutButtonTapped(_ sender: Any) {
//Setup activityIndicator
        activityIndicatorInit()
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = .white
//Logout...
        Client.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                
            }
        }
//Stop and hide activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
//Method for tapping refresh button
    @IBAction func refreshButtonTapped(_ sender: Any) {
//Setup activityIndicator
        activityIndicatorInit()
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = .white
//Load locations...
        getListOfStudentLocations()
//Stop and hide activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsData.sharedInstance().students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = StudentsData.sharedInstance().students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentsData.sharedInstance().students[indexPath.row]
        if let url = URL(string: student.mediaURL ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
