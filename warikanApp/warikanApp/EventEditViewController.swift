//
//  EventEditViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/11.
//

import UIKit
import RealmSwift

class EventEditViewController: UIViewController {
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
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventEditForm" {
            let nextView = segue.destination as! EventEditFormViewController
          nextView.event = event
        }
    }
    @IBAction func onAdd(_ sender: Any) {
        let targetVC = children[0] as! EventEditFormViewController
        if targetVC.action(){
            let preNC = self.presentingViewController as! UINavigationController
            // let preNC = self.navigationController as! UINavigationController でも可能かと思います
            let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! EventHomeViewController
            preVC.updateView()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
