//
//  Promise.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

/*
 In the absence of being able to use a Reactive library, this is a simple generic observable class

 It doesn't attempt to include any of the nice mapping features, threading features etc. due to time constraints.
 */

public final class Observable<V: Any, E: Error>: Lifecycle {

    private var result: Result<V, E>?
    private var cancelListener: (() -> Void)?
    private var resultListener: ((Result<V,E>) -> Void)?

    public init(value: V) {
        self.result = .success(data: value)
    }

    public init(error: E) {
        self.result = .failed(error: error)
    }

    public init(creationBlock: @escaping (Observer<V, E>, Lifecycle) -> Void) {
        let observer = Observer<V, E> { result in
            self.handleResultReceived(result: result)
        }

        creationBlock(observer, self)
    }

    public func blockingGet() -> Result<V, E> {
        while result == nil {
            sleep(1)
        }
        return result!
    }

    public func setLifecycleObserver(wasCancelled: @escaping () -> ()) {
        self.cancelListener = wasCancelled
    }

    public func cancel() {
        self.cancelListener?()
    }

    public func startWithResult(resultBlock: @escaping (Result<V,E>) -> Void) {
        self.resultListener = resultBlock
        if let existingResult = self.result {
            resultBlock(existingResult)
        }
    }

    private func handleResultReceived(result: Result<V, E>) {
        self.result = result
        self.resultListener?(result)
    }
}

public class Observer<V: Any, E: Error> {

    let resultListener: (Result<V, E>) -> Void

    init(resultListener: @escaping (Result<V,E>) -> Void) {
        self.resultListener = resultListener
    }

    public func setFinishedWithSuccess(value: V) {
        self.resultListener(Result<V, E>.success(data: value))
    }

    public func setFinishedWithFailure(error: E) {
        self.resultListener(Result<V, E>.failed(error: error))
    }
}

public protocol Lifecycle {
    func setLifecycleObserver(wasCancelled: @escaping () -> ())
}

public enum Result<V: Any, E: Error> {
    case success(data: V)
    case failed(error: E)
}
