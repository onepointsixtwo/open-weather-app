//
//  FiveDayForecastService.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import Foundation

protocol FiveDayForecastService {
    func getWeatherList(for location: CLLocation) -> Observable<Forecast, OpenWeatherError>
}

class FiveDayForecastServiceImpl: BaseOpenWeatherService, FiveDayForecastService {

    func getWeatherList(for location: CLLocation) -> Observable<Forecast, OpenWeatherError>  {
        let request = getRequest(for: location)
        let parser = WeatherListParser()
        let errorParser = OpenWeatherErrorParser()
        return networkStack.makeRequest(request: request, responseParser: parser, errorParser: errorParser)
    }

    private func getRequest(for location: CLLocation) -> Request {
        let fullURL = baseURL
            .appendingPathComponent("data")
            .appendingPathComponent("2.5")
            .appendingPathComponent("forecast")
        let headers = [String: String]()
        let additionalQueryParameters = ["lat": String(format: "%f", location.coordinate.latitude),
                                         "lon": String(format: "%f", location.coordinate.longitude)]
        let queryParameters = addAuthenticationToQueryParameters(queryParameters: additionalQueryParameters)
        return Request(method: .get, url: fullURL, headers: headers, queryParameters: queryParameters)
    }
}
