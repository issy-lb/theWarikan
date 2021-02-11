//
//  PayItem.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/01.
//

import Foundation
import RealmSwift

class Pay : Object{
    @objc dynamic var pay_id = NSUUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var amount = 0
    @objc dynamic var member_count = 1
    @objc dynamic var payer :Member?
    @objc dynamic var event :Event?
    @objc dynamic var delete = 0
    let payee = List<Member>()
    
    
    override static func primaryKey() -> String? {
        return "pay_id"
    }
}
