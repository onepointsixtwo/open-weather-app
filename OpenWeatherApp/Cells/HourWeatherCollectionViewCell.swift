//
//  HourWeatherCollectionViewCell.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation
import UIKit

class HourWeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    private var hour: Hour?
    private var imageLoaderFactory: WeatherImageLoaderFactory?

    private var currentLoader: WeatherImageLoader?

    func setHour(hour: Hour, imageLoaderFactory: WeatherImageLoaderFactory?) {
        currentLoader?.cancel()

        self.hour = hour
        self.imageLoaderFactory = imageLoaderFactory

        self.temperatureLabel.text = hour.temperature
        self.timeLabel.text = hour.time

        currentLoader = imageLoaderFactory?.getWeatherImageLoader(weather: hour.weather, imageView: imageView)
        currentLoader?.loadImageIntoImageView()
    }
}
