//
//  AddEventViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/07.
//

import UIKit

class AddEventViewController: UIViewController {
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
        let targetVC = children[0] as! AddEventFormViewController
        if targetVC.action(){
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // セグエ実行前処理

}
