//
//  EditPayViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/08.
//

import UIKit
import RealmSwift


class EditPayViewController: UIViewController {
    var pay:Pay!
    var event:Event!

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    // セグエ処理
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "showpayeditform" {
              let nextView = segue.destination as! EditPayFormViewController
            nextView.pay = pay
            nextView.event = event
          }
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onEdit(_ sender: Any) {
        let targetVC = children[0] as! EditPayFormViewController
        if targetVC.action(){
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onDelete(_ sender: Any) {
        PaytHelper().deletePay(pay:pay)
        dismiss(animated: true, completion: nil)
    }
}
