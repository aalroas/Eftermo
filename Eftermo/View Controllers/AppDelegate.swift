//
//  AppDelegate.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 14/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // for ios <  13 to  make StoryBoard Work
    var window: UIWindow?
    
    static var standard: AppDelegate {
           return UIApplication.shared.delegate as! AppDelegate
       }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // if user is logged in before
        if let loggedAccessToken = UserDefaults.standard.accessToken {
            print(loggedAccessToken)
            // instantiate the main tab bar controller and set it as root view controller
            // using the storyboard identifier we set earlier
            let home = storyboard.instantiateViewController(withIdentifier: "home")
            self.window?.rootViewController = home
        } else {
            // if user isn't logged in
            // instantiate the navigation controller and set it as root view controller
            // using the storyboard identifier we set earlier
            let login = storyboard.instantiateViewController(withIdentifier: "login")
            self.window?.rootViewController = login
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        
        window.rootViewController = vc
        
        // add animation
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft],
                          animations: nil,
                          completion: nil)
        
    }


}

