//
//  RootViewController.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 21/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import MapKit
import UIKit

/*
 Other than the creation of the dependencies, and a few minor additions this file was pretty much auto-generated
 and I haven't spent much time in cleaning it up for a quick demo project.
 */

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController: UIPageViewController!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var explanatoryLabel: UILabel!

    private var observable: Observable<Forecast, OpenWeatherError>?
    private var observable2: Observable<UIImage, OpenWeatherError>?

    let credentials = OpenWeatherCredentials(apiKey: "5c2c7e757185f2faa7dda8bfa413070d")
    let baseApiURL = URL(string: "https://api.openweathermap.org")!
    let baseImageURL = URL(string: "https://openweathermap.org")!
    var networkStack: NetworkStack!
    var forecastService: FiveDayForecastService!
    var iconService: IconService!

    override func viewDidLoad() {
        super.viewDidLoad()

        networkStack = URLSessionNetworkStack(urlSession: URLSession(configuration: URLSessionConfiguration.default))
        forecastService = FiveDayForecastServiceImpl(networkStack: networkStack, credentials: credentials, baseURL: baseApiURL)
        iconService = IconService(networkStack: networkStack, credentials: credentials, baseURL: baseImageURL)

        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self

        self.pageViewController!.dataSource = self.modelController

        self.addChildViewController(self.pageViewController!)
        self.pageViewController.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.pageViewController!.view, at: 1)
        self.view.bringSubview(toFront: addButton)

        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 0.0, dy: 0.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        self.pageViewController!.didMove(toParentViewController: self)

        //TODO: set up services
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController(pageViewController: pageViewController,
                                               storyboard: self.storyboard!,
                                               viewModelFactory: ForecastViewModelFactory(forecastService: forecastService),
                                               weatherImageLoaderFactory: WeatherImageLoaderFactory(iconService: iconService))
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

            self.pageViewController!.isDoubleSided = false
            return .min
        }

        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! ForecastViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

        return .mid
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let map = destination as? MapViewController {
            map.delegate = self
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController: MapViewControllerDelegate {
    func mapViewDidSelectCoordinates(coordinates: CLLocationCoordinate2D) {
        modelController.addNewLocation(location: coordinates)
        explanatoryLabel.isHidden = true
    }
}

