//
//  ModelController.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 21/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import MapKit
import UIKit

class ModelController: NSObject, UIPageViewControllerDataSource {

    let pageViewController: UIPageViewController
    let storyboard: UIStoryboard
    let viewModelFactory: ForecastViewModelFactory
    let weatherImageLoaderFactory: WeatherImageLoaderFactory
    private var pageData = [CLLocation]()

    init(pageViewController: UIPageViewController,
         storyboard: UIStoryboard,
         viewModelFactory: ForecastViewModelFactory,
         weatherImageLoaderFactory: WeatherImageLoaderFactory) {
        self.pageViewController = pageViewController
        self.storyboard = storyboard
        self.viewModelFactory = viewModelFactory
        self.weatherImageLoaderFactory = weatherImageLoaderFactory
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> ForecastViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! ForecastViewController
        let location = self.pageData[index]
        dataViewController.viewModel = viewModelFactory.getForecastViewModel(location: location)
        dataViewController.imageLoaderFactory = weatherImageLoaderFactory
        return dataViewController
    }

    func indexOfViewController(_ viewController: ForecastViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return pageData.index(of: viewController.viewModel.location) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ForecastViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ForecastViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func addNewLocation(location: CLLocationCoordinate2D) {
        pageViewController.dataSource = nil
        pageViewController.dataSource = self

        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        pageData.append(location)

        var controllers = self.pageViewController.viewControllers ?? [UIViewController]()
        if controllers.count == 0 {
            let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! ForecastViewController
            dataViewController.viewModel = viewModelFactory.getForecastViewModel(location: location)
            dataViewController.imageLoaderFactory = weatherImageLoaderFactory
            controllers.append(dataViewController)
            pageViewController.setViewControllers(controllers, direction: .forward, animated: true, completion: nil)
        }
    }
}

