//
//  ObservableField.swift
//  OpenWeatherApp
//
//  Created by Kartupelis, John on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

class ObservableField<T: Any> {

    private var value: T
    private var observer: ((T) -> ())?
    var get: T {
        return value
    }

    init(value: T) {
        self.value = value
    }

    func setObserver(_ observer: @escaping (T) -> ()) {
        self.observer = observer
        observer(value)
    }

    func setValue(value: T) {
        self.value = value
        observer?(value)
    }
}
