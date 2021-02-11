//
//  ViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2020/12/31.
//

import UIKit
import RealmSwift
import Instructions
var token:NotificationToken!
import FirebaseRemoteConfig


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CoachMarksControllerDataSource{
//    バージョンアップアラート
    let versionAlert: UIAlertController = UIAlertController(title: "アップデートのお知らせ", message:  "新規バージョンのアプリがご利用になれます。今すぐ最新バージョンにアップデートしてください。", preferredStyle:  UIAlertController.Style.alert)
    let goStoreAction: UIAlertAction = UIAlertAction(title: "アップデート", style: UIAlertAction.Style.default, handler:{
        // 確定ボタンが押された時の処理をクロージャ実装する
        (action: UIAlertAction!) -> Void in
        //実際の処理
        // App StoreのアプリのURL
        let appURL = "https://apps.apple.com/jp/app/id1550581637"
        guard let url = URL(string: appURL) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    })
    
    
    
//    チュートリアル
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var coachController = CoachMarksController()
    var eventList:Results<Event>!
    let realm = try! Realm()
    lazy var messages = ["ここからイベント追加"]
    lazy var views = [self.addBtn]
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCheck()
        
       
        
       
        

        
        //        コーチマーク
                self.coachController.dataSource = self
        // Do any additional setup after loading the view.
        
        token = realm.observe{notification, realm in
                              self.tableView.reloadData()
        }
        eventList = realm.objects(Event.self).filter("delete != 1").sorted(byKeyPath: "create_at", ascending: false)
        
        
//        UI
//        navigation
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        


    }
    
//    TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! eventTableViewCell
        let event = eventList[indexPath.row]
        cell.eventTitle.text = event.title
        cell.eventDate.text = EventHelper().dateformater(date: event.create_at)
        cell.eventAmount.text = "合計 \(EventHelper().getTotal(event: event))円"
        return cell
    }
    
//    コーチマーク
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "top"){
            super.viewDidAppear(animated)

            self.coachController.start(in: .window(over: self))
        }
        }

    override func viewWillDisappear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "top"){
            super.viewWillDisappear(animated)

            self.coachController.stop(immediately: true)
            UserDefaults.standard.set(true,forKey: "top")
        }
        }
    
//    イベント削除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            EventHelper().deleteEvent(event: eventList[indexPath.row], token: token)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // セグエ実行前処理
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
          // ②Segueの識別子確認
          if segue.identifier == "showEvent" {
            let indexPath = tableView.indexPathForSelectedRow
   
              // ③遷移先ViewCntrollerの取得
              let nextView = segue.destination as! EventHomeViewController
   
              // ④値の設定
            nextView.event = eventList[indexPath?.row ?? 0]
          }
      }
    func updateCheck(){
        
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch() { [weak self] status, error -> Void in
          if status == .success {
            print("Config fetched!")
            self?.remoteConfig.fetchAndActivate()
            guard let last_version = self?.remoteConfig["force_update_for_ios_app"].stringValue else { return }
            self?.alert(last_version: last_version)
                

              // ...
        }
        }


    }
    func alert(last_version:String){
        //        現在のアプリバージョン
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    print(version)
        print(last_version)
        
        if last_version.compare(version) == .orderedAscending{
            print("最新バージョン\(last_version)")
            print("旧バージョン\(version)")
            
                                        
        }else{
            self.versionAlert.addAction(self.goStoreAction)
            self.present(self.versionAlert, animated: true, completion: nil)
        }
        
        
//        if Double(version)! < Double(last_version) ?? 0.0{
//                            //        バージョンアップポップアップ
//                            self.versionAlert.addAction(self.goStoreAction)
//                            self.present(self.versionAlert, animated: true, completion: nil)
//
//                        }else{
//                            print("最新バージョンありません")
//                        }
    }


}

