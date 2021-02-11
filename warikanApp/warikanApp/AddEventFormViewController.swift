//
//  AddEventFormViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/06.
//

import UIKit
import Eureka
import RealmSwift

class AddEventFormViewController: FormViewController {
//    アラート
    let titleAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "イベント名を入力してください。", preferredStyle:  UIAlertController.Style.alert)
    let memberAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "メンバーは1人以上追加してください。", preferredStyle:  UIAlertController.Style.alert)
    let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
        // 確定ボタンが押された時の処理をクロージャ実装する
        (action: UIAlertAction!) -> Void in
        //実際の処理
    })
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        titleAlert.addAction(confirmAction)
        memberAlert.addAction(confirmAction)

        // Do any additional setup after loading the view.
        form +++ Section("イベント名")
                    <<< TextRow("title"){ row in
                        row.placeholder = "（例）卒業旅行"
                        
                    }
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "参加メンバー"
            ) {$0.tag = "members"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "メンバー追加"
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return TextRow("member_\(index+1)") {
                        $0.placeholder = "（例）山田太郎"
                    }
                }
                $0 <<< TextRow("member_1") {
                    $0.placeholder = "（例）山田太郎"
                }
            }
    }
    

    func action() -> Bool{
        let titleRow = form.rowBy(tag: "title") as! TextRow
        let title = titleRow.value ?? ""
        print("タイトル：\(title)")
        
        let members: [String]? = (form.sectionBy(tag: "members")?.compactMap { ($0 as? TextRow)?.value })

        if title == ""{
            present(titleAlert, animated: true, completion: nil)
            return false
        }else if (members?.count == 0) {
            present(memberAlert, animated: true, completion: nil)
            return false
        }else{
            EventHelper().addEvent(title: title, members: members!)
            return true
            
        }
    }

}
