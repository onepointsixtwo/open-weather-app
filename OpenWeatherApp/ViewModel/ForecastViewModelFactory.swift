//
//  ForecastViewModelFactory.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import Foundation

class ForecastViewModelFactory {
    private let forecastService: FiveDayForecastService

    init(forecastService: FiveDayForecastService) {
        self.forecastService = forecastService
    }

    func getForecastViewModel(location: CLLocation) -> ForecastViewModel {
        return ForecastViewModel(forecastService: forecastService, location: location)
    }
}
