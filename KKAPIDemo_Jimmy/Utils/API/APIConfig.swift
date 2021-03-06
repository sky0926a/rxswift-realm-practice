//
//  APIConfig.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/7.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

protocol APIActionProtocol { 
    var suffix: String { get }
    var urlString: String { get }
    var method: String { get }
}

enum APIServiceType {
    case api
    case oauth
}

extension APIServiceType {
    var domain: String {
        switch self {
        case .api:
            return "https://api.kkbox.com/"
        case .oauth:
            return "https://account.kkbox.com/"
        }
    }
    
    var route: String {
        switch self {
        case .api:
            return "v1.1/"
        case .oauth:
            return "oauth2/"
        }
    }
    
    var path: String {
        return domain + route
    }
    
}

enum APIAction {
    //MARK: GET
    enum GET {
        case playlists(id: String?)
        case category
    }
    //MARK: POST
    enum POST {
        case accessToken
    }
}

extension APIAction.GET: APIActionProtocol {
    var method: String {
        return "GET"
    }
    
    var suffix : String {
        switch self {
        case .playlists(let id):
            if let id: String = id, !id.isEmpty {
                return "featured-playlists/" + id
            }
            else {
                return "featured-playlists"
            }
        case .category:
            return "featured-playlist-categories"
        }
    }

    var urlString : String {
        switch self {
        default:
            return APIServiceType.api.path + suffix
        }
    }
}

extension APIAction.POST: APIActionProtocol {
    var method: String {
        return "POST"
    }
    
    var suffix : String {
        switch self {
        case .accessToken:
            return "token"
        }
    }

    var urlString : String {
        switch self {
        default:
            return APIServiceType.oauth.path + suffix
        }
    }
}

enum APIResult {
    case success(result: [String: Any])
    case failed
}
