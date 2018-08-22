//
//  NSURLSessionNetworkStack.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

// In fact, whole class is pretty quick and dirty. No proper error conversion really, and allows the URLSession error types to escape rather than converting them internally.
class URLSessionNetworkStack: NetworkStack {

    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func makeRequest<R, E>(request: Request,
                           responseParser: R,
                           errorParser: E) -> Observable<R.T, E.E> where R : ResponseParseable, E : ErrorParseable {
        let urlRequest = createUrlRequest(from: request)
        let observable = Observable<R.T, E.E> { [unowned self] (observer, lifecycle) in
            let task = self.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let data = data {
                    var parsed: R.T?
                    
                    do {
                        parsed = try responseParser.parseResponseData(data: data)
                    } catch {
                        print("Error attempting to parse data \(error)")
                    }

                    if let parsed = parsed {
                        observer.setFinishedWithSuccess(value: parsed)
                    } else {
                        observer.setFinishedWithFailure(error: errorParser.parseError(error: NetworkStackError.parseError))
                    }
                } else {
                    observer.setFinishedWithFailure(error: errorParser.parseError(error: error))
                }
            })
            task.resume()

            lifecycle.setLifecycleObserver {
                task.cancel()
            }
        }
        return observable
    }

    // Really,  really quick and dirty
    private func createUrlRequest(from request: Request) -> URLRequest {
        let queryParameters = request.queryParameters.map { (key, value) -> String in
            return "\(key)=\(value)"
            }.joined(separator: "&")
        let url = request.url.absoluteString + "?" + queryParameters
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
