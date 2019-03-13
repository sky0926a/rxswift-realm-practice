//
//  DataModel.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/13.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RealmSwift

extension List : Decodable where Element : Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}

extension List : Encodable where Element : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}

protocol ObjectProtocol: Codable {
    var id: String { get set}
    var title: String { get set}
    var imageUrl: String? { get}
}

