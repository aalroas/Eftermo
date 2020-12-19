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
    let statusBarView = UIView()
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor(red: 0.07, green: 0.09, blue: 0.13, alpha: 1.00))    //Background Color
        SVProgressHUD.show()
        
        let baseURL = URL(string: "https://eftermo.com/mobil/apple/mobilorta.php?webkbil=\(UserDefaults.standard.accessToken!)")
 
        myWebView.configuration.dataDetectorTypes = [.link]
        
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
         checkNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkLogin(uName: UserDefaults.standard.username!, uPassword:  UserDefaults.standard.password! , uDeviceToken: UserDefaults.standard.DeviceToken ?? "0") // son
    }
                
    
     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
        if navigationAction.navigationType == .linkActivated {
            
            guard let _ = navigationAction.request.url?.host?.hasPrefix("http://") else {
                    print("Link is not a url")
                    decisionHandler(.allow)
                    return
                }
            
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


    func checkNotification() {
        print("Checking Notification")
        if UserDefaults.standard.isNotificationPermissionGranted == false {

            if UserDefaults.standard.isNotificationPermissionDdismissed{
                return
            }
            let alert = UIAlertController(title: "Uygulama bildirimi",message: "Gelen mesaj bildirimini almak için bildiriminizi açın, Bildirimleri etkinleştirmek için Ayarlar'a gidin ve bu uygulama için bildirimleri etkinleştirin.", preferredStyle: UIAlertController.Style.alert)
            let settingsAction = UIAlertAction(title: "Ayarları aç", style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            })
           alert.addAction(settingsAction)

           let okAction = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
           alert.addAction(okAction)

            let DonntShowAction = UIAlertAction(title: "Bir daha gösterme", style: .default, handler: { _ in
                UserDefaults.standard.isNotificationPermissionDdismissed = true
               })
            alert.addAction(DonntShowAction)
            self.present(alert, animated: true, completion: nil)
        }
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


      
    
    func checkLogin(uName:String, uPassword:String,uDeviceToken:String){
        
        print("Checking Login")
       
        guard let url = URL(string: "https://eftermo.com/mobil/apple/userknt.php") else {
                    return
                }
               
                let data : Data =  "gkad=\(uName)&gsif=\(uPassword)&device_token=\(uDeviceToken)".data(using: .utf8)!
                var request : URLRequest = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
                request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
                request.httpBody = data
               
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: {
                    (data, response, error) in

                     if let error = error
                    {
                        print(error)
                    }
                     else if response != nil {
                        print("her in resposne")
                    }
                    DispatchQueue.main.async { // Correct
                        guard let responseData = data else {
                            print("Error: did not receive data")
                            return
                        }
                        let  accessToken = String(data: responseData, encoding: .utf8)!
                        if(accessToken != "0" ){
                            UserDefaults.standard.accessToken = accessToken
                            return
                        }
                     else {
                        // cikis yapmak istegini emin misin
                        let alert = UIAlertController(title: "Efermo", message: "kullanıcı adı veya şifre değiştirildi",preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Giriş Yap",style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
                        self.removeCookies()
                        UserDefaults.standard.removeAll()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginNavController = storyboard.instantiateViewController(withIdentifier: "login")
                        if #available(iOS 13.0, *) {
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
                        } else {
                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(loginNavController)
                        }
                       }))
                       self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
                task.resume()
        }
    
    

 
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    
    
    func removeCookies()  {
        let dataStore = self.myWebView.configuration.websiteDataStore
        let cookieStore = dataStore.httpCookieStore
        cookieStore.getAllCookies {
            $0.forEach { cookie in
                cookieStore.delete(cookie)
            }
        }
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record]) { }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func sendDeviceToken(uName:String,uPassword:String,uDeviceToken:String ){
        print("SendTokenIfcloseed")
        if UserDefaults.standard.accessToken == nil {
            print("no accessToken yet")
            return
        }
        print(UserDefaults.standard.DeviceToken ?? "No Token")
        print(UserDefaults.standard.accessToken ?? "No accessToken")
        guard let url = URL(string: "https://eftermo.com/mobil/apple/userknt.php") else {
                    return
                }

         let data : Data =  "gkad=\(uName)&gsif=\(uPassword)&device_token=\(uDeviceToken)".data(using: .utf8)!
                var request : URLRequest = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
                request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
                request.httpBody = data

                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task = session.dataTask(with: request, completionHandler: {
                    (data, response, error) in

                     if let error = error
                    {
                        print(error)
                    }
                     else if response != nil {
                        print("her in resposne")
                    }
                    DispatchQueue.main.async { // Correct
                        guard let responseData = data else {
                            print("Error: did not receive data")
                            return
                        }
                        let  accessToken = String(data: responseData, encoding: .utf8)!

                        if(accessToken != "0" ){
                            UserDefaults.standard.accessToken = accessToken
                            return
                        } else {
                            return
                        }
                    }
                })
                task.resume()
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
