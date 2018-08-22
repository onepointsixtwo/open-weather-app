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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingView: UIView!
    var viewModel: ForecastViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

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
}

//TODO: create the rows and display the data!
extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

