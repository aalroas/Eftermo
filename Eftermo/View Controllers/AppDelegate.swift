//
//  AppDelegate.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 14/11/2020.
//
import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    // for ios <  13 to  make StoryBoard Work
    var window: UIWindow?
    
    static var standard: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // if user is logged in before
        if let loggedAccessToken = UserDefaults.standard.accessToken {
            print(loggedAccessToken)
            let home = storyboard.instantiateViewController(withIdentifier: "home")
            self.window?.rootViewController = home
        } else {
            let login = storyboard.instantiateViewController(withIdentifier: "login")
            self.window?.rootViewController = login
        }
        
        Messaging.messaging().delegate = self
        
        // request permission from user to send notification
        registerForPushNotifications()
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
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound,.badge]) {
                [weak self] granted, error in
                UserDefaults.standard.isNotificationPermissionGranted = granted
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        //        UserDefaults.standard.DeviceToken = token
        //        print("Device Token: \(token)")
        
        //        if UserDefaults.standard.isNotificationPermissionGranted {
        //                let sendDeviceToken = HomeViewController()
        //                sendDeviceToken.sendDeviceToken(uName: UserDefaults.standard.username ?? "" ,uPassword: UserDefaults.standard.password ?? "" , uDeviceToken: UserDefaults.standard.DeviceToken ?? "0")
        //            }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //         reset badge count
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.badgeNumber = 0
        if !UserDefaults.standard.isNotificationPermissionGranted {
            if UserDefaults.standard.isNotificationPermissionDdismissed {
                return
            }
            print("burrdan geliyor")
            registerForPushNotifications()
        }
        
        
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        let aps = userInfo["aps"] as? [String: AnyObject]
        print("APN recieved")
        
        guard let badge = aps?["badge"] as? Int else { return }
        
        UserDefaults.standard.badgeNumber += badge
        UIApplication.shared.applicationIconBadgeNumber = UserDefaults.standard.badgeNumber
        
        completionHandler(.newData)
    }
    
    
    
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("first")
        print(userInfo)
        completionHandler([.alert,.sound])
        
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print("secend")
        print(userInfo)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loggedAccessToken = UserDefaults.standard.accessToken {
            print(loggedAccessToken)
            if let home = storyboard.instantiateViewController(withIdentifier: "home") as? TabBarViewController{
                //                    home.selectedIndex = 2
                self.window?.rootViewController = home
            }
        } else {
            let login = storyboard.instantiateViewController(withIdentifier: "login")
            self.window?.rootViewController = login
        }
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        UserDefaults.standard.DeviceToken = fcmToken
        if UserDefaults.standard.isNotificationPermissionGranted {
            let sendDeviceToken = HomeViewController()
            sendDeviceToken.sendDeviceToken(uName: UserDefaults.standard.username ?? "" ,uPassword: UserDefaults.standard.password ?? "" , uDeviceToken: UserDefaults.standard.DeviceToken ?? "0")
        }
    }
    
    
}

