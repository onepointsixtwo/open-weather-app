//
//  DataViewController.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 21/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import MapKit
import UIKit

class ForecastViewController: UIViewController {

    private let cellReuseIdentifier = "weather-day-cell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingView: UIView!
    var viewModel: ForecastViewModel!
    var imageLoaderFactory: WeatherImageLoaderFactory!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModelObservers()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stop()
    }

    @IBAction func tryAgain() {
        viewModel.retry()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "WeatherDayTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    private func setupViewModelObservers() {
        viewModel.errorVisible.setObserver { [unowned self] visible in
            self.errorView.isHidden = !visible
        }
        viewModel.loading.setObserver { [unowned self] loading in
            self.loadingView.isHidden = !loading
        }
        viewModel.tabularData.setObserver { [unowned self] _ in
            self.tableView.reloadData()
        }
        viewModel.title.setObserver { [unowned self] title in
            self.titleLabel.text = title
        }
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tabularData.get.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        if let weatherCell = cell as? WeatherDayTableViewCell {
            let day = viewModel.tabularData.get[indexPath.row]
            weatherCell.setDay(day: day, imageLoaderFactory: imageLoaderFactory)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

