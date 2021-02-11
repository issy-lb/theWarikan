//
//  InquiryViewController.swift
//  warikanApp
//
//  Created by 石田洋輔 on 2021/01/23.
//

import UIKit
import WebKit

class InquiryViewController: UIViewController,WKUIDelegate {
    let os = "\(UIDevice.current.systemName)　\(UIDevice.current.systemVersion)"
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let app = "The割り勘"
    let device = UIDevice.current.name
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // URL設定
        let urlString = "https://docs.google.com/forms/d/e/1FAIpQLScCoDBhKPP4ysqemZIKONrYEey724gUTMDFgQ7k-0Z4kumPyw/viewform?usp=pp_url&entry.430209894=\(app)&entry.1009755253=\(device)&entry.1708850629=\(os)&entry.135874652=\(version)"
               let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
               
               let url = NSURL(string: encodedUrlString!)
               let request = NSURLRequest(url: url! as URL)

               webView.load(request as URLRequest)

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
    
}
