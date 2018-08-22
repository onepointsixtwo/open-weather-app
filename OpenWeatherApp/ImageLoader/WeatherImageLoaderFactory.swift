//
//  WeatherImageLoaderFactory.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation
import UIKit

class WeatherImageLoaderFactory {

    let iconService: IconService
    let cache: NSCache<NSString, UIImage>

    init(iconService: IconService) {
        self.iconService = iconService
        //Lazily creating cache inside the factory rather than injecting
        cache = NSCache<NSString, UIImage>()
    }

    func getWeatherImageLoader(weather: Weather, imageView: UIImageView) -> WeatherImageLoader {
        return WeatherImageLoader(iconService: iconService, cache: cache, imageView: imageView, weather: weather)
    }
}
