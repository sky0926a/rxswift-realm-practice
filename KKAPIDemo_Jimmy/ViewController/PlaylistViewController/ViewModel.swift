//
//  ViewModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

class ViewModel: NSObject {
    
    var id: String?
    
    init(_ id: String? = nil) {
        self.id = id
    }
    
    lazy var data: Observable<[Playlist]> = {
        return getPlaylist(self.id).asObservable()
    }()
    
    func getPlaylist(_ id: String? = nil) -> Observable<[Playlist]> {
        return User.current.getPlayList(id).asObservable().map(parse)
    }
    
    func parse(json: Any) -> [Playlist] {
        if self.id != nil {
            return []
        }
        guard let data = json as? [String: Any], let items: [[String: Any]] = data["data"] as? [[String: Any]] else {
            print("data failed)")
            return []
        }
        
        var repositories = [Playlist]()
        items.forEach{
            guard let id = $0["id"] as? String,
                let title = $0["title"] as? String,
            let images = $0["images"] as? [[String: Any]] else {
                    return
            }
            let imageURLs: [Any] = images.map({ (item) -> Any in
                return item["url"]!
            })
            let playList: Playlist = Playlist(id: id, title: title, images: imageURLs)
            repositories.append(playList)
        }
        print("repositories:\(repositories.count)")
        return repositories
    }
}
