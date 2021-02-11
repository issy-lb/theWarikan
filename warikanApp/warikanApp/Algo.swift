//
//  Algo.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/10.
//

import Foundation
import RealmSwift
class Algo{
    let realm = try! Realm()
    let event:Event
   
    
    init(event:Event){
        self.event = event
        }
    func algo() -> [Result]{
//        準備
        var Owe = [String:[String:Int]]()
        var memPays = [memPay]()
        self.sumPay()
//        支払い配列作成
        event.members.forEach{
            let mempay = memPay()
            mempay.ID = $0.member_id
            mempay.name = $0.name
            mempay.owe = $0.claim - $0.payed
            memPays.append(mempay)
        }
//        支払い配列並び替え
        memPays.sort(by: {(a,b) -> Bool in
            return a.owe > b.owe
    })
//        支払い配列を表示
        memPays.forEach{
            print("----")
            print($0.name)
            print($0.owe)
        }
//        支払い結果配列初期化
        memPays.forEach{
            var owe = [String:Int]()
            memPays.forEach{
                owe[$0.ID] = 0
            }
            Owe[$0.ID]=owe
        }
//        支払い結果配列初期値プリント
        print("支払い結果配列初期値：\(Owe)")

//        支払いカウンター
        var counter = 1
        var borrower = 0
        var lender = memPays.count - 1
            while borrower < lender{
            let borrower_id = memPays[borrower].ID
            let lender_id = memPays[lender].ID
            if memPays[borrower].owe > -memPays[lender].owe {
                Owe[borrower_id]![lender_id]! = abs(memPays[lender].owe)
                memPays[borrower].owe += memPays[lender].owe
                memPays[lender].owe = 0
                lender -= 1
            }else if memPays[borrower].owe < -memPays[lender].owe{
                Owe[borrower_id]![lender_id]! = abs(memPays[borrower].owe)
                memPays[lender].owe += memPays[borrower].owe
                memPays[borrower].owe = 0
                borrower += 1
            }else{
                Owe[borrower_id]![lender_id]! = memPays[borrower].owe
                memPays[borrower].owe = 0
                memPays[lender].owe = 0
                lender -= 1
                borrower += 1
            }
                print("<<\(counter)>>回目")
                print(Owe)
                counter += 1
        }
        print(Owe)
        
//        結果返却
        var results = [Result]()
        memPays.forEach{
            let result = Result()
            result.name = $0.name
            result.repays = []
            let pays = Owe[$0.ID]
            memPays.forEach{
                if pays?[$0.ID] != 0{
                    let repay = Repay()
                    repay.name = $0.name
                    repay.amount = (pays?[$0.ID]!)!
                    result.repays.append(repay)
                }
            }
            results.append(result)
        }
        return results
    }
    
    func sumPay(){
        try! realm.write{
            event.members.forEach{
                $0.claim = 0
                $0.payed = 0
            }
        }
        if event.pays.count != 0{
        for i in 0 ... event.pays.count-1 {
            let pay = event.pays[i]
            let shareMem = pay.payee.count
            let ave = pay.amount / shareMem
            try! realm.write{
                pay.payer!.payed += pay.amount
                pay.payee.forEach{
                    $0.claim += ave
                }
            }
    }
        }
        
}
}
