//
//  ResultViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/09.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var eventLavel: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var event:Event!
    var results:[Result]!
    lazy var sections = EventHelper().makeSection(event: event)
    

//    テーブル
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results[section].repays.count == 0{
            return 1
        }else {
        return results[section].repays.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : UIView = UIView()
        let label : UILabel = UILabel()
        label.text = results[section].name
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.frame = CGRect(x:view.frame.minX + 10,y:view.frame.minY+40,width:80 ,height:40)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.backgroundColor = UIColor(displayP3Red: 0.25, green: 0.38, blue: 0.71, alpha: 1.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        label.frame.size.width += 40
        label.frame.size.height += 20
        view.addSubview(label)

                    return view
        }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        if results[indexPath.section].repays.count == 0{
            cell.textLabel!.text = "支払いなし"
            cell.detailTextLabel!.text = ""
            return cell;
        }else{
        cell.textLabel!.text = "\(results[indexPath.section].repays[indexPath.row].name)へ"
        cell.detailTextLabel!.text = "\(results[indexPath.section].repays[indexPath.row].amount)円"
                return cell;
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        eventLavel.text = event.title
        //        テーブルのUI
        self.tableView.sectionHeaderHeight = 80
        results = Algo(event: event).algo()
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

        //    画面のサイズ
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            let mainBoundSize: CGSize = UIScreen.main.bounds.size
            if CGFloat(tableView.contentSize.height) < mainBoundSize.height * 0.6 {
                
                viewHeight.constant = mainBoundSize.height*0.9
                tableHeight.constant = mainBoundSize.height*0.9
            }else{
            tableHeight.constant = CGFloat(tableView.contentSize.height)+100
            viewHeight.constant = CGFloat(tableView.contentSize.height)+200
            }
        }
        
    @IBAction func onShare(_ sender: Any) {
        let lineSchemeMessage: String! = "line://msg/text/"  // /textを指定
        var shareText = "[清算結果]\(event.title)\n ********** \n"
        results.forEach{
            shareText += "【\($0.name)】\n"
            if $0.repays.count == 0{
                shareText += "支払いなし\n"
            }else{
                $0.repays.forEach{
                    shareText += "\($0.name)　へ　\($0.amount)円\n"
                }
            }
            shareText += "\n"
        }
        shareText += "**********"
        var scheme: String! = lineSchemeMessage + shareText
        scheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        UIApplication.shared.open(URL(string: scheme)!)
    }
}
