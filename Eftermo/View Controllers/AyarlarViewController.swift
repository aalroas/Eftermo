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
 
        UserDefaults.standard.removeAll()
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
    
}
