//
//  AyarlarViewController.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 16/11/2020.
//

import UIKit
import WebKit
import Foundation
import SVProgressHUD
import SafariServices

class AyarlarViewController: UIViewController, SFSafariViewControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtton(_ sender: Any) {
        // cikis yapmak istegini emin misin
        let alert = UIAlertController(title: "Eftermo", message: "Aktivisyonu Kaldırmak  istediğinizden emin misiniz?",preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: UIAlertAction.Style.cancel, handler: { _ in
          }))
        alert.addAction(UIAlertAction(title: "Evet",style: UIAlertAction.Style.destructive,handler: {(_: UIAlertAction!) in
        self.updateDeviceToken(uName: UserDefaults.standard.username ?? "" ,uPassword: UserDefaults.standard.password ?? "" , uDeviceToken: "0")
        UIApplication.shared.unregisterForRemoteNotifications()

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
    
    @IBAction func openUrl(_ sender: Any) {
        let urlString = "https://eftermo.com/"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
 
    @IBAction func cihazKurulumu(_ sender: Any) {
        let urlString = "https://eftermo.com/tr/eftermo-kurulum"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    func updateDeviceToken(uName:String,uPassword:String,uDeviceToken:String ){
        if UserDefaults.standard.username == nil {
            print("no username yet")
            return
        }
        if UserDefaults.standard.password == nil {
            print("no password yet")
            return
        }
        
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
                            UserDefaults.standard.removeAll()
                            return
                        } else {
                            return
                        }
                    }
                })
                task.resume()
        }
    
}
