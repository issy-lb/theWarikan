//
//  EditPayFormViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/08.
//

import UIKit
import Eureka
import RealmSwift

class EditPayFormViewController: FormViewController {
    var pay:Pay!
    var event:Event!
    var name:String!
    let realm = try! Realm()
    var members=[String]()
    var payeeList = List<Member>()
    var payer:Member!
    let titleAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "支払いタイトルを入力してください。", preferredStyle:  UIAlertController.Style.alert)
    let amountAlert: UIAlertController = UIAlertController(title: "もう少し！", message:  "金額(１円以上)を入力してください。", preferredStyle:  UIAlertController.Style.alert)
    let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
        // 確定ボタンが押された時の処理をクロージャ実装する
        (action: UIAlertAction!) -> Void in
        //実際の処理
    })
    
override func viewDidLoad() {
    
        super.viewDidLoad()
    
    //        ダイアログ
            titleAlert.addAction(confirmAction)
            amountAlert.addAction(confirmAction)
    
        // Do any additional setup after loading the view.
    for i in 0...event.members.count-1{
    members.append(event.members[i].name)
    }
//    for i in 0 ... event.members.count-1{
//        members.append(event.members[i].name)
//    }
    title = "NEW PAY"
        form +++ Section("支払い内容")
                    <<< TextRow("title"){ row in
                        row.title = "タイトル"
                        row.placeholder = "（例）ガソリン代"
                        row.value = pay.title
                    }
                    <<< IntRow("amount"){
                        $0.title = "金額"
                        $0.placeholder = "（例）4,300"
                        $0.value = pay.amount
                    }
                +++ Section("支払いメンバー")
                    <<<  ActionSheetRow<String>("payer") {
                        $0.title = "支払った人"
                        $0.options = members
                        $0.value = pay.payer?.name  // initially selected
                            }
            +++ Section(header:"支払い対象メンバー",footer:"                 \n \n \n \n           ")
    for i in 0...event.members.count-1{
        form[2]
    <<< CheckRow(String(i)) {
                        $0.title = members[i]
        if pay.payee.contains(event.members[i]){
            $0.value = true
        } else{
            $0.value = false
        }
                        
                    }
    }
    }
    func action() -> Bool{
        let titleRow = form.rowBy(tag: "title") as! TextRow
        let title = titleRow.value ?? ""
        
        let amountRow = form.rowBy(tag: "amount") as! IntRow
        let amount = amountRow.value ?? 0
        
        
        let payerRow = form.rowBy(tag: "payer") as! ActionSheetRow<String>
        let Payer = payerRow.value!
        let num = members.firstIndex(of:String(Payer))
        payer = event.members[num!]
            for i in 0 ... members.count-1{
                let payeeRow = form.rowBy(tag: String(i)) as! CheckRow
                let payee = payeeRow.value!
                if payee{
                    payeeList.append(event.members[i])
                }
        }
        
        if title == ""{
            present(titleAlert, animated: true, completion: nil)
            return false
        }else if amount == 0{
            present(amountAlert, animated: true, completion: nil)
            return false
        }else{
            PaytHelper().editPay(pay:pay,title: title, amount: amount, payer: payer ,payee: payeeList, event: event,member_count:payeeList.count)
            return true
        }
        
        

    }

}
