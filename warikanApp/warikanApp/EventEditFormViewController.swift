//
//  EventEditFormViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/11.
//

import UIKit
import Eureka
import RealmSwift

class EventEditFormViewController: FormViewController {
    //    アラート
        let titleAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "イベント名を入力してください。", preferredStyle:  UIAlertController.Style.alert)
        let memberAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "メンバーは1人以上追加してください。", preferredStyle:  UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })
    var addNum = 0
        
    var event:Event!
    var members:[Member]!

    override func viewDidLoad() {
        super.viewDidLoad()
//        ダイアログ
        titleAlert.addAction(confirmAction)
        memberAlert.addAction(confirmAction)
        
        members = []
        event.members.forEach{
            members.append($0)
        }
        
        form +++ Section("イベント名")
                    <<< TextRow("title"){ row in
                        row.placeholder = "（例）卒業旅行"
                        row.value = event.title
                        
                    }
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "参加メンバー",footer:"                 \n \n \n \n           "
            ) {$0.tag = "members"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "メンバー追加"
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return TextRow("newMember_\(self.addNum)") {
                        $0.placeholder = "（例）山田太郎"
                        self.addNum += 1
                    }
                }
                for i in 0 ... members.count-1{
                    $0 <<< TextRow("member_\(i)") {
                        $0.placeholder = "（例）山田太郎"
                        $0.value = members[i].name
                }
                }
            }
        
     
        // Do any additional setup after loading the view.
    }
    func action() -> Bool{
        let titleRow = form.rowBy(tag: "title") as! TextRow
        let title = titleRow.value ?? ""
        
        
//        新しいメンバー
        var newMembers = [String]()
        if (self.addNum != 0){
            for i in 0 ... self.addNum-1{
                let newMember = form.rowBy(tag: "newMember_\(i)") as? TextRow
                if newMember!.value != nil{
                newMembers.append(newMember!.value!)
                }
            }
        }
//        削除メンバー
        var deleteMembers = [String]()
        for i in 0 ... members.count-1{
            let memRow = form.rowBy(tag: "member_\(i)") as? TextRow
            if memRow == nil || memRow?.value == nil{
                deleteMembers.append(event.members[i].member_id)
            }
        }
//        旧メンバー
        var old_members = [String:String]()
        for i in 0 ... members.count-1{
            let member = form.rowBy(tag: "member_\(i)") as? TextRow
            old_members[members[i].member_id] = member?.value
        }
//        メンバー全員
        let all_members: [String]? = (form.sectionBy(tag: "members")?.compactMap { ($0 as? TextRow)?.value })
        if title == ""{
            present(titleAlert, animated: true, completion: nil)
            return false
        }else if (all_members?.count == 0) {
            present(memberAlert, animated: true, completion: nil)
            return false
        }else{
            EventHelper().editEvent(event:event,title:title,members:old_members,deleteMembers:deleteMembers,newMembers:newMembers)
            return true
            
        }

    }


}
