//
//  BildirimlerViewController.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 16/11/2020.
//

import UIKit
import WebKit
import Foundation
import SVProgressHUD
import SafariServices

class BildirimlerViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,SFSafariViewControllerDelegate {

    @IBOutlet weak var myWebView: WKWebView!
    let statusBarView = UIView()
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor(red: 0.07, green: 0.09, blue: 0.13, alpha: 1.00))    //Background Color
        SVProgressHUD.show()
        
        let baseURL = URL(string:"https://eftermo.com/mobil/apple/bildirimler.php?webkbil=\(UserDefaults.standard.accessToken!)")
 
        let myRequest = URLRequest(url: baseURL!)
        myWebView.load(myRequest)
        
        myWebView.uiDelegate = self
        myWebView.scrollView.showsHorizontalScrollIndicator = false
        myWebView.scrollView.showsVerticalScrollIndicator = false
        myWebView.navigationDelegate = self
        
        view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
      statusBarView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        
    }

 

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }

     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
                guard let url = navigationAction.request.url else {
                    print("Link is not a url")
                    decisionHandler(.allow)
                    return
                }
            if (url.host == "www.eftermo.com"){
                    print("Open link locally")
                    decisionHandler(.allow)
            } else {
                
              
                if let safariUrl = URL(string: url.absoluteString) {
                    let vc = SFSafariViewController(url: safariUrl)
                    vc.delegate = self
                    present(vc, animated: true)
                }
                    print("Redirected to browser.")
                    decisionHandler(.cancel)
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
            }
        
         
        }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
        checkInternet()
    }

 
        func checkInternet(){
        if !Helper.app.isInternetAvailable(){
        let alert = UIAlertController(title: "İnternet bağlantısı yok", message: "İnternet bağlantısı yok, lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Tamam", style: .default) { ( _ ) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  exit(0)
                 }
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        }
            
        }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
