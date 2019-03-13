//
//  API.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/7.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]
public typealias JSON = Any

enum APIError: Error {
    case failed
    case decodeError
}

extension Dictionary where Key == String {
    var toParameters: String {
        return keys.reduce("?", { (url, key) -> String in
            return url + "&\(key)=\(String(describing: self[key]!))"
        })
    }
    var toBody: String {
        var body: String =  keys.reduce("", { (url, key) -> String in
            return url + "\(key)=\(String(describing: self[key]!)),"
        })
        if body.count > 0 {
            body.removeLast()
        }
        return body
    }
}

private enum APIURLFormat {
    case get(action: APIAction.GET, parameters: Parameters?, header: HTTPHeaders?)
    case post(action: APIAction.POST, parameters: Parameters?, body: Parameters?, header: HTTPHeaders?)
}

extension APIURLFormat {
    var request: URLRequest? {
        switch self {
        case .get(let action, let parameters, let header):
            let urlString: String = action.urlString + (parameters?.toParameters ?? "")
            print(urlString)
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = action.method
                request.allHTTPHeaderFields = header
                return request
            }
        case .post(let action, let parameters, let body, let header):
            let urlString: String = action.urlString + (parameters?.toParameters ?? "")
            print(urlString)
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = action.method
                request.allHTTPHeaderFields = header
                request.httpBody = body?.toBody.data(using: .utf8)
                return request
            }
        }
        return nil
    }
}

class API {
    
    static let shared: API = API()
    
    func get<T: Codable>(_ action: APIAction.GET, parameters: Parameters? = nil, headers: HTTPHeaders?) -> Single<T> {
        return Single<T>.create(subscribe: { (single) -> Disposable in
            var parameter: Parameters = [:]
            if let merge = parameters {
                parameter.merge(merge) { (_, new) -> Any in new }
            }
            var header: HTTPHeaders = ["accept": "application/json"]
            if let merge = headers {
                header.merge(merge) { (_, new) -> String in new }
            }
            if let request: URLRequest = APIURLFormat.get(action: action, parameters: parameters, header: headers).request {
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        guard let data = data else {
                            single(.error(APIError.failed))
                            return
                        }
                        if let dict = try? JSONDecoder().decode(T.self, from: data) {
                            single(.success(dict))
                        }
                        else {
                            single(.error(APIError.failed))
                        }
                    }
                }
                task.resume()
                return Disposables.create { task.cancel() }
            }
            else {
                single(.error(APIError.failed))
                return Disposables.create()
            }
        })
    }
    
    func post(_ action: APIAction.POST, parameters: Parameters? = nil, body: Parameters?, headers: HTTPHeaders?) -> Single<JSON> {
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
            var parameter: Parameters = [:]
            if let merge = parameters {
                parameter.merge(merge) { (_, new) -> Any in new }
            }
            var header: HTTPHeaders = [ "Content-Type": "application/x-www-form-urlencoded"]
            if let merge = headers {
                header.merge(merge) { (_, new) -> String in new }
            }
            if let request: URLRequest = APIURLFormat.post(action: action, parameters: parameters, body: body, header: headers).request {
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        guard let data = data else {
                            single(.error(APIError.failed))
                            return
                        }
                        if let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                            single(.success(dict))
                        }
                        else {
                            single(.error(APIError.failed))
                        }
                    }
                }
                task.resume()
                return Disposables.create { task.cancel() }
            }
            else {
                single(.error(APIError.failed))
                return Disposables.create()
            }
        })
    }
    
}

