//
//  BaseOpenWeatherService.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

class BaseOpenWeatherService {

    let networkStack: NetworkStack
    let baseURL: URL

    private let credentials: OpenWeatherCredentials

    init(networkStack: NetworkStack,
         credentials: OpenWeatherCredentials,
         baseURL: URL) {
        self.networkStack = networkStack
        self.credentials = credentials
        self.baseURL = baseURL
    }

    func addAuthenticationToQueryParameters(queryParameters: [String: String]) -> [String: String] {
        var authParams = ["APPID": credentials.apiKey]
        queryParameters.forEach { (key, value) in
            authParams[key] = value
        }
        return authParams
    }
}

