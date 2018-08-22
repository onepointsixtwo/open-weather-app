//
//  ForecastViewModelTests.swift
//  OpenWeatherAppTests
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import Foundation
import XCTest
@testable import OpenWeatherApp

class ForecastViewModelTests: XCTestCase {

    let location = CLLocation(latitude: 1.0, longitude: 2.0)
    let mockService = MockFiveDayForecastService()
    var viewModel: ForecastViewModel!

    override func setUp() {
        viewModel = ForecastViewModel(forecastService: mockService, location: location)
    }

    func testErrorResponse() {
        mockService.error = true
        viewModel.start()

        XCTAssertTrue(viewModel.errorVisible.get)
    }

    func testCorrectLocationUsed() {
        mockService.error = true
        viewModel.start()

        XCTAssertEqual(location, mockService.lastLocationUsed)
    }

    func testGoodResponse() {
        mockService.forecast = getGoodForecastResponse()
        viewModel.start()

        XCTAssertEqual(viewModel.tabularData.get.count, 1)
        XCTAssertEqual(viewModel.tabularData.get[0].hours.count, 2)
        XCTAssertEqual(viewModel.tabularData.get[0].hours[0].temperature, "20.0°C")
    }

    private func getGoodForecastResponse() -> Forecast {
        var items = [WeatherListItem]()

        let now = Date()
        items.append(WeatherListItem(dt: now, weather: [Weather(icon: "1b", main: "")], main: Main(temp: 293.15)))
        items.append(WeatherListItem(dt: now, weather: [Weather(icon: "2b", main: "")], main: Main(temp: 295.15)))

        return Forecast(list: items)
    }
}

class MockFiveDayForecastService: FiveDayForecastService {
    var error = false
    var forecast: Forecast?
    var lastLocationUsed: CLLocation?

    func getWeatherList(for location: CLLocation) -> Observable<Forecast, OpenWeatherError> {
        lastLocationUsed = location

        if let forecast = forecast,
            error == false {
            return Observable<Forecast, OpenWeatherError>(value: forecast)
        }
        return Observable<Forecast, OpenWeatherError>(error: OpenWeatherError.general)
    }
}
