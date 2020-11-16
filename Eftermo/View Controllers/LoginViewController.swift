//
//  ViewController.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 14/11/2020.
//

import UIKit
import Foundation
import SVProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
 
    
        guard let url = URL(string: "https://eftermo.com/mobil/apple/userknt.php") else {
                    return
                }
        SVProgressHUD.show()
        if(usernameTextField.text!.isEmpty){
            SVProgressHUD.dismiss()
            Helper.app.showAlert(title: "Hata", message: "kullanıcı adı alanı boş", vc: self)
         return
        }
        if(passwordTextField.text!.isEmpty){
          SVProgressHUD.dismiss()
          Helper.app.showAlert(title: "Hata", message: "Şifre alanı boş", vc: self)
          return
        }
        
        
        
        let data : Data =  "gkad=\(usernameTextField.text!)&gsif=\(passwordTextField.text!)".data(using: .utf8)!
                var request : URLRequest = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
                request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
                request.httpBody = data
                print("one called")
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
                        UserDefaults.standard.username = self.usernameTextField.text
                        UserDefaults.standard.password = self.passwordTextField.text
//                        if UserDefaults.standard.isNotificationPermissionGranted {
//                            let sendDeviceToken = HomeViewController()
//                            sendDeviceToken.sendDeviceToken(uAccessToken: UserDefaults.standard.accessToken ?? "" , UdeviceToken: UserDefaults.standard.DeviceToken ?? "")
//                        }
                        SVProgressHUD.dismiss()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let homeController = storyboard.instantiateViewController(withIdentifier: "home")
                        if #available(iOS 13.0, *) {
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeController)
                        } else {
                            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController(homeController)
                        }
                     }else{
                         SVProgressHUD.dismiss()
                         Helper.app.showAlert(title: "Hata", message: "kullanıcı adı veya şifre yanlış", vc: self)
                        }
                    }
                })
                task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    
    
  
}
    extension LoginViewController {
       
       
    func initializeHideKeyboard(){
    //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
    target: self,
    action: #selector(dismissMyKeyboard))
    //Add this tap gesture recognizer to the parent view
    view.addGestureRecognizer(tap)
       
    }
      
       
   
       
    @objc func dismissMyKeyboard(){
    //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
    //In short- Dismiss the active keyboard.
    view.endEditing(true)
    }
       
    
   }



