//
//  MemberItem.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import Foundation
import RealmSwift

class Member : Object{
    @objc dynamic var member_id = NSUUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var payed = 0
    @objc dynamic var claim = 0
    let pays = LinkingObjects(fromType: Pay.self, property: "payer")
    
    override static func primaryKey() -> String? {
        return "member_id"
    }
}
