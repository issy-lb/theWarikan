//
//  EventItem.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import Foundation
import RealmSwift

class Event : Object{
    @objc dynamic var event_id = NSUUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var create_at = Date()
    @objc dynamic var delete = 0
    let members = List<Member>()
    let pays = LinkingObjects(fromType: Pay.self, property: "event")
    
    override static func primaryKey() -> String? {
        return "event_id"
    }
}
