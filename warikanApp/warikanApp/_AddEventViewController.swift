//
//  AddEventViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import UIKit
import RealmSwift


class _AddEventViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var member1: UITextField!
    @IBOutlet weak var member2: UITextField!
    @IBOutlet weak var member3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAdd(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
    

}
