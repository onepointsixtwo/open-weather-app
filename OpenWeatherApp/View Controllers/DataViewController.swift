//
//  DataViewController.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 21/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import MapKit
import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: CLLocation!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = String(format: "%.02f, %.02f", dataObject.coordinate.latitude, dataObject.coordinate.longitude)
    }
}

