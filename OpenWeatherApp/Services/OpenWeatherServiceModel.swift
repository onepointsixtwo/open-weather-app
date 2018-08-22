//
//  OpenWeatherServiceModel.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

struct WeatherList: Codable {
    let list: [WeatherListItem]
}

struct WeatherListItem: Codable {
    let dt: Date
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let icon: String
    let main: String
}

struct Main: Codable {
    let temp: Double
}

enum OpenWeatherError: Error {
    case general
}

//TODO: move out parsers.
class WeatherListParser: ResponseParseable {
    typealias T = WeatherList

    func parseResponseData(data: Data) throws -> WeatherList {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(WeatherList.self, from: data)
    }
}

class OpenWeatherErrorParser: ErrorParseable {
    typealias E = OpenWeatherError

    func parseError(error: Error?) -> OpenWeatherError {
        return .general
    }
}
