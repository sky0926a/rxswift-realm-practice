//
//  TrackListModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/11.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RealmSwift

class TracksModel: Object, Codable {
    var tracks: TracksDataModel = TracksDataModel()
    enum CodingKeys: String, CodingKey {
        case tracks
    }
}

class TracksDataModel: Object, Codable {
    var data: [TracksListModel] = [TracksListModel]()
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class TracksListModel: Object, ObjectProtocol {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var duration: Int = 0
    @objc dynamic var isFavorited: Bool = false
    @objc dynamic var album: TrackListAlbum!

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case url
        case duration
        case album
    }

    var imageUrl: String? {
        return album?.images.first?.url
    }
}

class TrackListAlbum: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var artist: TrackListArtist!
    var images = List<ModelImage>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class TrackListArtist: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var url: String = ""
    var images = List<ModelImage>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
