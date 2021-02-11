//
//  AddPayViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import UIKit

class AddPayViewController:UIViewController {
    var name = "parent"
    var event:Event!
override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.    
    

}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onAdd(_ sender: Any) {
        let targetVC = children[0] as! AddPayForm
        if targetVC.action(){
        dismiss(animated: true, completion: nil)
        }
    }
    // セグエ処理
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "showform" {
              let nextView = segue.destination as! AddPayForm
            nextView.event = event
          }
      }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
