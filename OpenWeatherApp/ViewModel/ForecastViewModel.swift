//
//  ForecastViewModel.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import CoreLocation
import Foundation

struct Day {
    let date: Date
    let title: String
    var hours: [Hour]
}

struct Hour {
    let date: Date
    let time: String
    let temperature: String
    let weather: Weather
}

class ForecastViewModel {

    private static let absoluteZeroInCelsius: Double = -273.15

    private let forecastService: FiveDayForecastService
    public let location: CLLocation

    public let loading: ObservableField<Bool> = ObservableField(value: false)
    public let errorVisible: ObservableField<Bool> = ObservableField(value: false)
    public let tabularData: ObservableField<[Day]> = ObservableField(value: [Day]())
    public let title: ObservableField<String> = ObservableField(value: "")

    private var currentServiceRequest: Cancellable?

    private var hoursFormatter: DateFormatter {
        let dt = DateFormatter()
        dt.dateFormat = "HH:mm"
        dt.timeZone = TimeZone.current
        dt.locale = Locale.current
        return dt
    }
    private var dayFormatter: DateFormatter {
        let dt = DateFormatter()
        dt.dateFormat = "EEEE, d MMMM"
        dt.timeZone = TimeZone.current
        dt.locale = Locale.current
        return dt
    }

    init(forecastService: FiveDayForecastService,
         location: CLLocation) {
        self.forecastService = forecastService
        self.location = location
        self.title.setValue(value:String(format: "Weather at (%.02f, %.02f)", location.coordinate.latitude, location.coordinate.longitude))
    }

    func start() {
        loadData()
    }

    func retry() {
        loadData()
    }

    func stop() {
        currentServiceRequest?.cancel()
    }

    private func loadData() {
        loading.setValue(value: true)
        errorVisible.setValue(value: false)

        currentServiceRequest = forecastService.getWeatherList(for: location).startWithResult(resultBlock: { [unowned self] result in
            self.loading.setValue(value: false)
            switch result {
            case .failed(let error):
                self.handleFailure(error: error)
            case .success(let forecast):
                self.handleSuccess(forecast: forecast)
            }
        })
    }

    private func handleSuccess(forecast: Forecast) {
        let days = convertForecastToDayList(forecast: forecast)
        tabularData.setValue(value: days)
    }

    private func handleFailure(error: OpenWeatherError) {
        errorVisible.setValue(value: true)
    }

    private func convertForecastToDayList(forecast: Forecast) -> [Day] {
        var days = [Day]()
        var currentHours = [Hour]()
        forecast.list.forEach { item in
            if let date = currentHours.first?.date {
                if itemBelongsInDate(item: item, date: date) {
                    currentHours.append(hourFromItem(item: item))
                } else {
                    days.append(dayFromHours(hours: currentHours, date: date))
                    currentHours.removeAll()
                    currentHours.append(hourFromItem(item: item))
                }
            } else {
                currentHours.append(hourFromItem(item: item))
            }
        }

        if let date = currentHours.first?.date {
            days.append(dayFromHours(hours: currentHours, date: date))
        }

        return days
    }

    private func itemBelongsInDate(item: WeatherListItem, date: Date) -> Bool {
        return Calendar.current.isDate(item.dt, inSameDayAs: date)
    }

    private func hourFromItem(item: WeatherListItem) -> Hour {
        let temperature = String(format: "%.1f°C", kelvinToCelsius(kelvin: item.main.temp))
        let time = hoursFormatter.string(from: item.dt)
        // Unsafe unwrapping only used for time saving.
        return Hour(date: item.dt, time: time, temperature: temperature, weather: item.weather.first!)
    }

    private func dayFromHours(hours: [Hour],
                              date: Date) -> Day {
        let title = dayFormatter.string(from: date)
        return Day(date: date, title: title, hours: hours)
    }

    private func kelvinToCelsius(kelvin: Double) -> Double {
        return kelvin + ForecastViewModel.absoluteZeroInCelsius
    }
}
