//
//  IconService.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation
import UIKit

class PNGParser: ResponseParseable {
    typealias T = UIImage

    func parseResponseData(data: Data) throws -> UIImage {
        if let img = UIImage(data: data) {
            return img
        }
        throw OpenWeatherError.general
    }
}

class IconService: BaseOpenWeatherService {

    func fetchIcon(for weather: Weather) -> Observable<UIImage, OpenWeatherError>  {
        if let url = iconURL(for: weather) {
            let request = Request(method: .get, url: url, headers: [String: String](), queryParameters: addAuthenticationToQueryParameters(queryParameters: [String: String]()))
            let responseParser = PNGParser()
            let errorParser = OpenWeatherErrorParser()
            return networkStack.makeRequest(request: request, responseParser: responseParser, errorParser: errorParser)
        }
        return Observable<UIImage, OpenWeatherError>(error: OpenWeatherError.general)
    }

    private func iconURL(for weather: Weather) -> URL? {
        let path = "https://openweathermap.org/img/w/\(weather.icon).png"
        return URL(string: path)
    }
}
