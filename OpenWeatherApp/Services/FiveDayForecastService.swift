//
//  FiveDayForecastService.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import Foundation

struct WeatherList {
    let list: [WeatherListItem]
}

struct WeatherListItem {
    let dt: Date
    let weather: Weather
    let temp: Temp
}

struct Weather {
    let icon: String
    let main: String
}

struct Temp {
    let temp: Double
}

enum FiveDayForecastServiceError: Error {
    case general
}

class FiveDayForecastService {

    let networkStack: NetworkStack

    init(networkStack: NetworkStack) {
        self.networkStack = networkStack
    }

    func getWeatherList(for location: CLLocation) -> Observable<WeatherList, FiveDayForecastServiceError>  {
        return nil
    }
}
