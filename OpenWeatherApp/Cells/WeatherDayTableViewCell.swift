//
//  WeatherDayTableViewCell.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation
import UIKit

class WeatherDayTableViewCell: UITableViewCell {

    let cellReuseIdentifier = "hour-weather-cell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private var day: Day?
    private var imageLoaderFactory: WeatherImageLoaderFactory?

    override func awakeFromNib() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)

        collectionView.register(UINib(nibName: "HourWeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }

    func setDay(day: Day,
                imageLoaderFactory: WeatherImageLoaderFactory) {
        self.day = day
        self.imageLoaderFactory = imageLoaderFactory

        self.titleLabel.text = day.title
        self.collectionView.reloadData()
    }
}

extension WeatherDayTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return day?.hours.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        if let hourCell = cell as? HourWeatherCollectionViewCell,
            let hour = day?.hours[indexPath.row] {
            hourCell.setHour(hour: hour, imageLoaderFactory: imageLoaderFactory)
        }
        return cell
    }
}
