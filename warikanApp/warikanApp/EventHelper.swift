//
//  EventHelper.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import Foundation
import RealmSwift

class EventHelper{
    let realm = try! Realm()
    func addEvent(title:String,members:[String]){
        let event = Event()
        event.title = title
        event.create_at = Date()
        for i in 0 ... members.count-1{
            let member = Member()
            member.name = members[i]
            event.members.append(member)
        }        
        try! realm.write{
            realm.add(event)
        }
    }
    
    
    
    func deleteEvent(event:Event,token:NotificationToken){
        try! realm.write(withoutNotifying: [token]){
            event.delete = 1
    }
    }
    func editEvent(event:Event,title:String,members:[String:String],deleteMembers:[String],newMembers:[String]){

        try! realm.write{
//         イベント名編集
            event.title = title

//         メンバー削除
            event.members.forEach{
                if deleteMembers.contains($0.member_id){
                print("削除")
                print($0)
                let pay = $0.pays
                print(pay)
                realm.delete(pay)
                realm.delete($0)
                
                }
            }
//         メンバー編集
            event.members.forEach{
                $0.name = members[$0.member_id]!
            }
//         メンバー追加
            newMembers.forEach{
            let member = Member()
                member.name = $0
                event.members.append(member)
        }
        }
        
    }

    
    
    func deletePay(pay:Pay,token:NotificationToken){
        try! realm.write(withoutNotifying: [token]){
            realm.delete(pay)
    }
    }
    
    func makeSection(event:Event) -> [String]{
        var sections = [String]()
        for i in 0 ... event.members.count-1{
            let section = event.members[i].name
            sections.append(section)
        }
        return sections
    }
    
    func getTotal(event:Event) -> String {
        var result: Int = 0
        if event.pays.count == 0{
            result = 0
        }else{
        for i in 0 ... event.pays.count-1{
            result += event.pays[i].amount
        }
        }
        return self.kugiri(num: result)
    }
    func getAve(event:Event) -> String {
        var result: Int = 0
        let members = event.members.count
        if members == 0 || event.pays.count == 0 {
            result = 0
        }else{
            var total:Int = 0
            for i in 0 ... event.pays.count-1{
                total += event.pays[i].amount
            }
            result = total/members
        }
        return self.kugiri(num: result)
    }
    func kugiri(num:Int) -> String {
        let formatter: NumberFormatter = NumberFormatter()

        // スタイルを指定
        formatter.numberStyle = .decimal
        // 数値の区切り文字を指定する
        formatter.groupingSeparator = ","
        // 何桁ごとに区切り文字を入れるか指定する
        formatter.groupingSize = 3
        // 123456をフォーマットする
        return formatter.string(from: NSNumber.init(integerLiteral: num))!
    }
    func dateformater(date:Date) -> String{
        let date = date
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: date)        
    }
    

}
