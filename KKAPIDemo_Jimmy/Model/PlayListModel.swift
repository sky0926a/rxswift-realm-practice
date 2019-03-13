//
//  PlayListModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/11.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RealmSwift

class PlayList: Object, Codable {
    var data: [PlayListModel] = [PlayListModel]()
    enum CodingKeys: String, CodingKey {
        case data
    }
}

class PlayListModel: Object, ObjectProtocol {
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var updatedTime: String = ""
    var images: [ModelImage] = [ModelImage]()

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case desc = "description"
        case updatedTime = "updated_at"
        case images
    }

    var imageUrl: String? {
        return images.first?.url
    }
}

class ModelImage: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    @objc dynamic var url: String = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
}
