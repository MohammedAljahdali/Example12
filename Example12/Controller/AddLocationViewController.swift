//
//  AddLocationViewController.swift
//  PinSample
//
//  Created by Ammar AlTahhan on 19/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToNotificationsObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotificationsObserver()
    }
    
    @IBAction func findLocationTapped(_ sender: UIButton) {
        guard let location = locationTextField.text,
              let mediaLink = mediaLinkTextField.text,
              location != "", mediaLink != "" else {
            self.showAlert(title: "Missing information", message: "Please fill both fields and try again")
            return
        }
        
        let studentLocation = StudentLocation(mapString: location, mediaURL: mediaLink)
        geocodeCoordinates(studentLocation)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        let ai = self.startAnActivityIndicator()
        // TODO: Use CLGeocoder's function named `geocodeAddressString` to convert location's `mapString` to coordinates
        
            // TODO: Call `ai.stopAnimating()` first thing in the completionHandler
            
            // TODO: Extract the first location from Place Marks array
            
            // TODO: Copy studentLocation into a new object and save latitude and longitude in the new object's properties `latitude` and `longitude`
            
            
            
            // TODO: Call performSegue using `mapSegue` identifier and pass `location` as the sender
            
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelTapped(_:)))
        
        locationTextField.delegate = self
        mediaLinkTextField.delegate = self
    }
    
    @objc private func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}


