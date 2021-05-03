//
//  Helper.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 14/11/2020.
//

import Foundation
import SystemConfiguration
import UIKit
class Helper {
    
    static var app: Helper = {
          return Helper()
      }()
    
        
    func showAlert(title: String, message:String, vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
    alert.addAction(okAction)
    vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func changeView(viewID: String, vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: viewID)
        vc.show(secondVC, sender: self)
    }
    
    func isInternetAvailable() -> Bool
     {
         var zeroAddress = sockaddr_in()
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)

         let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
             $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                 SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
             }
         }

         var flags = SCNetworkReachabilityFlags()
         if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
             return false
         }
         let isReachable = flags.contains(.reachable)
         let needsConnection = flags.contains(.connectionRequired)
         return (isReachable && !needsConnection)
     }
    
    
}
