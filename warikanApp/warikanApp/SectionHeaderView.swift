//
//  SectionHeaderView.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/02.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var name: UILabel!
    
    
    
    func setup(title: String) {
        name.text = title
        name.layer.cornerRadius = 20
        //書き出す文字列にサイズを合わす
        name.sizeToFit()
        //余白となるサイズを加える
        name.frame.size.width += 20
        name.frame.size.height += 5
        
        }

}
