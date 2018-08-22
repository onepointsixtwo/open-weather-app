//
//  MapViewController.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 21/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

/*
    For speed, the logic in this file has not been separated out into a presenter or view model but were this a 'real' app it would have been.
 */
protocol MapViewControllerDelegate: class {
    func mapViewDidSelectCoordinates(coordinates: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    weak var delegate: MapViewControllerDelegate?

    private let geocoder = CLGeocoder()

    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var map: MKMapView!

    private var currentCoordinate: CLLocationCoordinate2D?
    private var currentAnnotation: MKPointAnnotation?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        coordinatesLabel.text = ""

        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapMap(tapGestureRecogniser:)))
        self.map.addGestureRecognizer(tapGestureRecogniser)
    }

    override func viewWillDisappear(_ animated: Bool) {
        geocoder.cancelGeocode()
    }

    @IBAction func didTapMap(tapGestureRecogniser: UITapGestureRecognizer) {
        let tapPoint = tapGestureRecogniser.location(in: map)
        let coordinates = map.convert(tapPoint, toCoordinateFrom: map)
        addMarkerAtPoint(coordinates: coordinates)
        zoomToCoordinatesRegion(coordinates: coordinates)
        setLabelValue(coordinates: coordinates)
    }

    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func chooseLocation() {
        if let coordinate = currentCoordinate {
            delegate?.mapViewDidSelectCoordinates(coordinates: coordinate)
        }
        dismiss(animated: true, completion: nil)
    }

    private func addMarkerAtPoint(coordinates: CLLocationCoordinate2D) {
        if let currentAnnotation = currentAnnotation {
            map.removeAnnotation(currentAnnotation)
        }

        currentCoordinate = coordinates

        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinates
        map.addAnnotation(pointAnnotation)
        currentAnnotation = pointAnnotation
    }

    private func zoomToCoordinatesRegion(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        map.setRegion(region, animated: true)
    }

    private func setLabelValue(coordinates: CLLocationCoordinate2D) {
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { [unowned self] (placemarks, error) in
            var placeName = "unknown"
            if let placemarks = placemarks,
                let first = placemarks.first,
                let name = first.locality {
                placeName = "around " + name
            }
            self.coordinatesLabel.text = String(format: "%.03f, %.03f - %@", coordinates.latitude, coordinates.longitude, placeName)
        }
    }
}
