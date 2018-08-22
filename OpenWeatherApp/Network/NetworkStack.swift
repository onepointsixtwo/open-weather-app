//
//  NetworkStack.swift
//  OpenWeatherApp
//
//  Created by John Kartupelis on 22/08/2018.
//  Copyright © 2018 John Kartupelis. All rights reserved.
//

import Foundation

enum NetworkStackError: Error {
    case parseError
}

enum Method {
    case get
}

struct Request {
    let method: HTTPCookie
    let url: URL
    let headers: [String: String]
    let queryParameters: [String: String]
}

protocol ResponseParseable {
    associatedtype T

    func parseResponseData(data: Data) -> T?
}

protocol ErrorParseable {
    associatedtype E: Error

    func parseError(error: Error?) -> E
}

protocol NetworkStack {
    func makeRequest<R: ResponseParseable, E: ErrorParseable>(request: Request, responseParser: R, errorParser: E) -> Observable<R.T, E.E>
}
