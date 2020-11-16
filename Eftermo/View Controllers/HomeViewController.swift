//
//  HomeViewController.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 16/11/2020.
//



import UIKit
import WebKit
import Foundation
import SVProgressHUD
import SafariServices
class HomeViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,SFSafariViewControllerDelegate {

    @IBOutlet weak var myWebView: WKWebView!

    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor(red: 0.07, green: 0.09, blue: 0.13, alpha: 1.00))    //Background Color
        SVProgressHUD.show()
        
        let baseURL = URL(string:"https://eftermo.com/mobil/apple/mobilorta.php?webkbil=\(UserDefaults.standard.accessToken!)")
 
        let myRequest = URLRequest(url: baseURL!)
        myWebView.load(myRequest)
        
        myWebView.uiDelegate = self
        myWebView.scrollView.showsHorizontalScrollIndicator = false
        myWebView.scrollView.showsVerticalScrollIndicator = false
        myWebView.navigationDelegate = self
    }

 

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let username = UserDefaults.standard.username ?? ""
//        let password = UserDefaults.standard.password ?? ""
        SVProgressHUD.dismiss()
//        checkNotification()
    }

     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated {
                guard let url = navigationAction.request.url else {
                    print("Link is not a url")
                    decisionHandler(.allow)
                    return
                }
            if (url.host == "www.eftermo.com"){
    //            if url.absoluteString == "https://eftermo.com/logout" {
    //                  self.removeCookies()
    //                  UserDefaults.standard.removeAll()
    //                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //                  let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")
    //                  if #available(iOS 13.0, *) {
    //                      (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    //                  } else {
    //                      (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
    //                  }
    //            }
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


//    func checkNotification() {
//        print("Checking Notification")
//        if UserDefaults.standard.isNotificationPermissionGranted == false {
//
//            if UserDefaults.standard.isNotificationPermissionDdismissed{
//                return
//            }
//            let alert = UIAlertController(title: "Uygulama bildirimi",message: "Gelen mesaj bildirimini almak için bildiriminizi açın, Bildirimleri etkinleştirmek için Ayarlar'a gidin ve bu uygulama için bildirimleri etkinleştirin.", preferredStyle: UIAlertController.Style.alert)
//            let settingsAction = UIAlertAction(title: "Ayarları aç", style: .default, handler: { _ in
//                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    })
//                }
//            })
//           alert.addAction(settingsAction)
//
//           let okAction = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
//           alert.addAction(okAction)
//
//            let DonntShowAction = UIAlertAction(title: "Bir daha gösterme", style: .default, handler: { _ in
//                UserDefaults.standard.isNotificationPermissionDdismissed = true
//               })
//            alert.addAction(DonntShowAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }


//        func removeCookies()  {
//            let dataStore = self.myWebView.configuration.websiteDataStore
//            let cookieStore = dataStore.httpCookieStore
//            cookieStore.getAllCookies {
//                $0.forEach { cookie in
//                    cookieStore.delete(cookie)
//                }
//            }
//            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//                records.forEach { record in
//                    dataStore.removeData(ofTypes: record.dataTypes, for: [record]) { }
//                }
//            }
//        }


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


//        func checkLogin(uName:String, uPassword:String){
//
//        print("Checking Login")
//        guard let url = URL(string: "https://www.pi.finanspi.com/api/auth") else {
//                    return
//                }
//        let data : Data =  "username=\(uName)&password=\(uPassword)&server_key=56ef57705487e1954a2fbd0a1882404e4bb3a0c3-fc12b2efb86e258aa228832a71d465fd-79130275".data(using: .utf8)!
//                var request : URLRequest = URLRequest(url: url)
//                request.httpMethod = "POST"
//                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
//                request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
//                request.httpBody = data
//
//                let config = URLSessionConfiguration.default
//                let session = URLSession(configuration: config)
//                let task = session.dataTask(with: request, completionHandler: {
//                    (data, response, error) in
//
//                     if let error = error
//                    {
//                        print(error)
//                    }
//                     else if response != nil {
//                        print("her in resposne")
//                    }
//                    DispatchQueue.main.async { // Correct
//                        guard let responseData = data else {
//                            print("Error: did not receive data")
//                            return
//                        }
//                     let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
//                     if(json!["access_token"] != nil ){
//                         return
//                     }
//                     else {
//                        // cikis yapmak istegini emin misin
//                        let alert = UIAlertController(title: "Finanspi", message: "kullanıcı adı veya şifre değiştirildi",preferredStyle: UIAlertController.Style.alert)
//
//                        alert.addAction(UIAlertAction(title: "Giriş Yap",style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
//                        self.removeCookies()
//                        UserDefaults.standard.removeAll()
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")
//                        if #available(iOS 13.0, *) {
//                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
//                        } else {
//                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
//                        }
//                       }))
//                       self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                })
//                task.resume()
//        }


//func sendDeviceToken(uAccessToken:String,UdeviceToken:String ){
//    print("SendTokenIfcloseed")
//    if UserDefaults.standard.accessToken == nil {
//        print("no accessToken yet")
//        return
//    }
//    print(UserDefaults.standard.DeviceToken ?? "No Token")
//    print(UserDefaults.standard.accessToken ?? "No accessToken")
//    guard let url = URL(string: "https://www.pi.finanspi.com/api/update-user-data?access_token=\(uAccessToken)") else {
//                return
//            }
//    let data : Data =  "ios_n_device_id=\(UdeviceToken)&server_key=56ef57705487e1954a2fbd0a1882404e4bb3a0c3-fc12b2efb86e258aa228832a71d465fd-79130275".data(using: .utf8)!
//            var request : URLRequest = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
//            request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
//            request.httpBody = data
//
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//            let task = session.dataTask(with: request, completionHandler: {
//                (data, response, error) in
//
//                 if let error = error
//                {
//                    print(error)
//                }
//                 else if response != nil {
//                    print("her in resposne")
//                }
//                DispatchQueue.main.async { // Correct
//                    guard let responseData = data else {
//                        print("Error: did not receive data")
//                        return
//                    }
//                 let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
//                 if(json!["api_status"] != nil ){
//                    print(json!["api_status"])
//                     return
//                 }
//                }
//            })
//            task.resume()
//    }




    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
