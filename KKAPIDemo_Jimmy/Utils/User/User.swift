//
//  User.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/7.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation

private let KKboxTokenKey: String = "kkbox.api.token"

class User {
    static let current: User = User()
    
    func getToken() {
        let auth: String = "\(appID):\(appSecret)".data(using: .utf8)!.base64EncodedString()
        let header: HTTPHeaders = ["Authorization": "Basic \(auth)"]
        let body: Parameters = ["grant_type": "client_credentials"]
        _ = API.shared.post(.accessToken, body: body, headers: header).subscribe(onSuccess: { (reuslt) in
            print(reuslt)
        }, onError: { (error) in
            print(error)
        })
    }
    
    
}

extension User {
    var token: String {
        set {
            UserDefaults.standard.set(newValue, forKey: KKboxTokenKey)
        }
        get {
            return UserDefaults.standard.string(forKey: KKboxTokenKey) ?? ""
        }
    }
}


