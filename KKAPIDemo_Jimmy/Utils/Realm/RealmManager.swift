//
//  RealmManager.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/11.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private enum RealmSyntaxType {
        case add
        case delete
    }
    
    private var database: Realm
    static let db = RealmManager()
    
    private init() {
        database = try! Realm()
    }
    
    private func tryWrite(_ object: Object, syntaxType: RealmSyntaxType, handler: RealmHandler? = nil) {
        do {
            try database.write {
                switch syntaxType {
                case .add:
                    database.add(object, update: true)
                case .delete:
                    database.delete(object)
                    break
                }
            }
            handler?(true)
        } catch {
            handler?(false)
        }
    }
    
    private func tryWrite<S: Sequence>(_ objects: S, syntaxType: RealmSyntaxType) -> Bool where S.Iterator.Element: Object {
        do {
            try database.write {
                switch syntaxType {
                case .add:
                    database.add(objects, update: true)
                case .delete:
                    database.delete(objects)
                }
            }
            return true
        } catch {
            return false
        }
    }
}

typealias RealmHandler = (Bool) -> ()

extension RealmManager {
    func add(_ object: Object, handler: RealmHandler?) {
        return tryWrite(object, syntaxType: .add, handler: handler)
    }
    
    func add<S: Sequence>(_ objects: S) -> Bool where S.Iterator.Element: Object {
        return tryWrite(objects, syntaxType: .add)
    }
    
    func delete(_ object: Object, handler: RealmHandler?){
        return tryWrite(object, syntaxType: .delete, handler: handler)
    }
    
    func delete<S: Sequence>(_ objects: S) -> Bool where S.Iterator.Element: Object {
        return tryWrite(objects, syntaxType: .delete)
    }
    
    func query<T: Object>() -> Results<T> {
        return database.objects(T.self)
    }
    
    func update(write: (Realm) -> (), handler: RealmHandler?) {
        do {
            try database.write {
                write(database)
            }
            handler?(true)
        } catch {
            handler?(false)
        }
    }
}
