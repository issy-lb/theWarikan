//
//  EventHomeViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import UIKit
import RealmSwift
import Instructions

class EventHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource{
    
    
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
                coachViews.bodyView.hintLabel.text = self.messages[index] // ここで文章を設定
                coachViews.bodyView.nextLabel.text = "OK！" // 「次へ」などの文章

                return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return self.coachController.helper.makeCoachMark(for: self.views[index], pointOfInterest: nil, cutoutPathMaker: nil)
                // for: にUIViewを指定すれば、マークがそのViewに対応します
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return self.messages.count
    }
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var summary: UIView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var average: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!

    
   
    
    
    var coachController = CoachMarksController()
    var bl = false

    @IBOutlet weak var seisanButton: UIBarButtonItem!
    
    var event:Event!
    lazy var sections = EventHelper().makeSection(event: event)
    lazy var messages = ["このボタンで支払い追加"]
    lazy var views = [self.addBtn]
    var token:NotificationToken!
    let realm = try! Realm()
    @IBOutlet weak var tableView: UITableView!
    
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        コーチマーク
        self.coachController.dataSource = self
//        ダークモード非適応
        self.overrideUserInterfaceStyle = .light
        
       
        
        
        
        // Do any additional setup after loading the view.
        eventTitle.text = event.title
        token = realm.observe{notification, realm in
            self.sections = EventHelper().makeSection(event: self.event)
                self.tableView.reloadData()
                  self.updateView()
          
        }

        
//        サマリーの描画
        total.text = EventHelper().getTotal(event: event)
        average.text = "1人平均　\(EventHelper().getAve(event: event))円"
        
//        ナビゲーションの色
        // 半透明の指定（デフォルト値）
            self.navigationController?.navigationBar.isTranslucent = true
            // 空の背景画像設定
            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
            // ナビゲーションバーの影画像（境界線の画像）を空に設定
            self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        
        

        seisanButton.image =  UIImage(named: "seisan.png")?.withRenderingMode(.alwaysOriginal)
        

//        settingButton.image = UIImage(named: "setting.png")?.withRenderingMode(.alwaysOriginal)
       
//        テーブルのUI
        self.tableView.sectionHeaderHeight = 80

        
//        サマリーのUI
//        summary.layer.cornerRadius = 40
//
//        summary.layer.shadowOffset = CGSize(width: 0, height: 6.0)
//        summary.layer.shadowColor = UIColor.black.cgColor
//        summary.layer.shadowOpacity = 0.8
//        summary.layer.shadowRadius = 12
//

        summary.layer.cornerRadius = 40
        summary.layer.shadowColor = UIColor.black.cgColor
        summary.layer.shadowRadius = 3
        summary.layer.shadowOffset = CGSize(width: 1, height: 1)
        summary.layer.shadowOpacity = 0.2
        

    }
//    画面のサイズ
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        
        if CGFloat(tableView.contentSize.height) < mainBoundSize.height * 0.6 {
            
            viewHeight.constant = mainBoundSize.height
            tableHeight.constant = mainBoundSize.height*0.6
        }else{
        tableHeight.constant = CGFloat(tableView.contentSize.height)+20
        viewHeight.constant = CGFloat(tableView.contentSize.height)+250
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
        }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : UIView = UIView()
        let label : UILabel = UILabel()
        view.backgroundColor = UIColor.white
        label.text = sections[section]
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.frame = CGRect(x:view.frame.minX + 10,y:view.frame.minY+40,width:80 ,height:40)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.backgroundColor = UIColor(displayP3Red: 0.45, green: 0.67, blue: 0.61, alpha: 1.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.sizeToFit()
        label.frame.size.width += 40
        label.frame.size.height += 20
        view.addSubview(label)
                   
        
                    return view
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if event.members[section].pays.count == 0{
            return 1}else{
                return event.members[section].pays.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "payCell", for: indexPath)
        cell.textLabel?.numberOfLines=0
        if event.members[indexPath.section].pays.count == 0{
            cell.textLabel!.text = "支払いなし"
            cell.detailTextLabel!.text = ""
        }else{
        cell.textLabel!.text = event.members[indexPath.section].pays[indexPath.row].title
        cell.detailTextLabel!.text = "\(EventHelper().kugiri(num:event.members[indexPath.section].pays[indexPath.row].amount)) 円"
        }
                return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPay" {
            let nextView = segue.destination as! AddPayViewController
          nextView.event = event
        }
        if segue.identifier == "showPayEdit" {
          let indexPath = tableView.indexPathForSelectedRow
 
            // ③遷移先ViewCntrollerの取得
            let nextView = segue.destination as! EditPayViewController
 
            // ④値の設定
          nextView.pay = event.members[indexPath?.section ?? 1].pays[indexPath?.row ?? 1]
            nextView.event = event
            
    }
    if segue.identifier == "showResult" {
        let nextView = segue.destination as! ResultViewController
      nextView.event = event
    }
    if segue.identifier == "showEventEdit" {
        let nextView = segue.destination as! EventEditViewController
      nextView.event = event
    }
        
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == "showPayEdit"){
            let indexPath = tableView.indexPathForSelectedRow
            if event.members[indexPath?.section ?? 0].pays.count == 0{
                return false
            }
        }
        return true
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "home"){
            super.viewDidAppear(animated)

            self.coachController.start(in: .window(over: self))
        }
        }

    override func viewWillDisappear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "home"){
            super.viewWillDisappear(animated)

            self.coachController.stop(immediately: true)
            UserDefaults.standard.set(true,forKey: "home")
        }
        }
    
    
    func updateView(){
        //表示の更新
        total.text = EventHelper().getTotal(event: event)
        eventTitle.text = event.title
        
        average.text = "1人平均　\(EventHelper().getAve(event: event))円"
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        
        if CGFloat(tableView.contentSize.height) < mainBoundSize.height * 0.8 {
            
            viewHeight.constant = mainBoundSize.height*0.9
            tableHeight.constant = mainBoundSize.height*0.9
        }else{
        tableHeight.constant = CGFloat(tableView.contentSize.height)
        viewHeight.constant = CGFloat(tableView.contentSize.height)+200
        }
        print("OKOK")
    }

    

}
