//
//  User.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/7.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

private let KKboxTokenKey: String = "kkbox.api.token"
private let appID = "a492682e320074df920c10f06f64725c"
private let appSecret = "8a5074250bf43560e83a527bb803fc9c"

class User {
    static let current: User = {
        let user = User()
        return user
    }()
    
}

extension User {
    func getToken() -> Single<String> {
        return Single<String>.create { (single) -> Disposable in
            if !User.current.APIToken.isEmpty {
                single(.success(User.current.APIToken))
            }
            else {
                _ = User.current.fetchServerToken().subscribe(onSuccess: { (token) in
                    User.current.APIToken = token
                    if !token.isEmpty {
                        single(.success(token))
                    }
                    else {
                        single(.error(APIError.failed))
                    }
                }, onError: { (error) in
                    single(.error(error))
                })
            }
            return Disposables.create()
        }
    }
    
    func getPlayList(_ id: String? = nil) -> Single<JSON> {
        return Single<JSON>.create(subscribe: { (single) -> Disposable in
            _ = User.current.getToken().asObservable().map({ (result) -> Bool in
                return !result.isEmpty
            }).bind(onNext: { [weak self] (hasToken) in
                if hasToken {
                    _ = self?.fetchServerPlaylist(id).subscribe(onSuccess: { (result) in
                        single(.success(result))
                    }, onError: { (error) in
                        single(.error(error))
                    })
                }
            })
            return Disposables.create()
        })
    }
    
}

extension User {
    func fetchServerToken() -> Single<String> {
        let auth: String = User.current.auth
        let header: HTTPHeaders = ["Authorization": "Basic \(auth)"]
        let body: Parameters = ["grant_type": "client_credentials"]
        return API.shared.post(.accessToken, body: body, headers: header)
            .map({ (json) -> String in
                if let json: [String: Any] = json as? [String: Any],
                    let access_token: String = json["access_token"] as? String {
                    return access_token
                }
                else {
                    return ""
                }
            })
    }
    
    func fetchServerPlaylist(_ id: String? = nil) -> Single<JSON> {
        let header: HTTPHeaders = ["Authorization": "Bearer \(APIToken)"]
        let parameters: Parameters = ["territory": "TW",
                                      "offset": 0,
                                      "limit": 500]
        return API.shared.get(.playlists(id: id), parameters: parameters, headers: header)
            .map({ (json) -> JSON in
                print(json)
                return json
            })
    }
}

extension User {
    private var APIToken: String {
        set {
            UserDefaults.standard.set(newValue, forKey: KKboxTokenKey)
        }
        get {
            return UserDefaults.standard.string(forKey: KKboxTokenKey) ?? ""
        }
    }
    
    private var auth: String {
        return "\(appID):\(appSecret)".data(using: .utf8)!.base64EncodedString()
    }
}


