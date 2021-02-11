//
//  PayHelper.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/01.
//

import Foundation
import RealmSwift

class PaytHelper{
    let realm = try! Realm()
    func addPay(title:String,amount:Int,payer:Member,payee:List<Member>,event:Event,member_count:Int){
        let pay = Pay()
        pay.title = title
        pay.amount = amount
        pay.payer = payer
        pay.event = event
        pay.member_count = member_count
        for i in 0 ... payee.count-1{
            pay.payee.append(payee[i])
        }
        try! realm.write{
            realm.add(pay)
        }
    }
    func editPay(pay:Pay,title:String,amount:Int,payer:Member,payee:List<Member>,event:Event,member_count:Int){
        try! realm.write{
            pay.title = title
            pay.amount = amount
            pay.payer = payer
            pay.member_count = member_count
            pay.payee.removeAll()
            for i in 0 ... payee.count-1{
                pay.payee.append(payee[i])
            }

        }
    }
    func deletePay(pay:Pay){
        try! realm.write{
            realm.delete(pay)
        }
    }
}
