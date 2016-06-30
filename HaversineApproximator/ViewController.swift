//
//  ViewController.swift
//  HaversineApproximator
//
//  Created by Andy on 28/06/2016.
//  Copyright © 2016 andywhale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var longitudeTextField : UITextField!
    @IBOutlet var latitudeTextField : UITextField!
    @IBOutlet var resultsTextView : UITextView!
    
    // Default is currently set to York
    let haversineApproximator = HaversineApproximatorModel(latitude: 53.959965, longitude: -1.087298)
    
    @IBAction func calculateTapped(sender : AnyObject) {
        haversineApproximator.longitude = Double((longitudeTextField.text! as NSString).doubleValue)
        haversineApproximator.latitude = Double((latitudeTextField.text! as NSString).doubleValue)
        
        let distances = haversineApproximator.calculateDistance()
        
        var results = ""
        for (placeName, distance) in distances {
            results += "\(placeName): \(distance) miles\n"
        }
        resultsTextView.text = results
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        longitudeTextField.resignFirstResponder()
    }
    
    func refreshUI() {
        longitudeTextField.text = String(format: "%0.6f", haversineApproximator.longitude)
        latitudeTextField.text = String(format: "%0.6f", haversineApproximator.latitude)
        resultsTextView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

