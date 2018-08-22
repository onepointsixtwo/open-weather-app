//
//  ImageLoader.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation
import UIKit

class WeatherImageLoader {

    let iconService: IconService
    let cache: NSCache<NSString, UIImage>
    let imageView: UIImageView
    let weather: Weather

    var currentLoad: Cancellable?

    init(iconService: IconService,
         cache: NSCache<NSString, UIImage>,
         imageView: UIImageView,
         weather: Weather) {
        self.iconService = iconService
        self.cache = cache
        self.imageView = imageView
        self.weather = weather
    }

    func loadImageIntoImageView() {
        if let existing = existingCacheValue() {
            imageView.image = existing
        }

        currentLoad = iconService.fetchIcon(for: weather).startWithResult(resultBlock: { [unowned self] result in
            switch result {
            case .success(let image):
                self.imageDidLoad(image: image)
            default:
                break
            }
        })
    }

    func cancel() {
        currentLoad?.cancel()
    }

    private func imageDidLoad(image: UIImage) {
        imageView.image = image
        cache.setObject(image, forKey: weather.icon as NSString)
    }

    private func existingCacheValue() -> UIImage? {
        return cache.object(forKey: weather.icon as NSString)
    }
}
