//
//  PayArray.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/11.
//

import Foundation
class memPay{
    var ID:String = ""
    var name = ""
    var owe = 0
}

class Result{
    var name = ""
    var repays:[Repay]!
}

class Repay{
    var name = ""
    var amount = 0
}
