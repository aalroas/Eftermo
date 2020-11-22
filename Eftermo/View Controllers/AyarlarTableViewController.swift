//
//  AyarlarTableViewController.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 20/11/2020.
//

import UIKit

class AyarlarTableViewController: UITableViewController {

    @IBOutlet weak var servisDurumu: UISwitch!
    @IBOutlet weak var anlikBildirim: UISwitch!
    @IBOutlet weak var akilliBildirim: UISwitch!
    @IBOutlet weak var smsBildirim: UISwitch!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servisDurumu.isOn = UserDefaults.standard.ServisDurumuStatus
        anlikBildirim.isOn =  UserDefaults.standard.anlikBildirimStatus
        akilliBildirim.isOn =  UserDefaults.standard.akilliBildirimStatus
        smsBildirim.isOn =  UserDefaults.standard.smsBildirimStatus
        
        servisDurumu.addTarget(self, action: #selector(stateChangedServisDurumu), for: .valueChanged)
        anlikBildirim.addTarget(self, action: #selector(stateChangedAnlikBildirim), for: .valueChanged)
        akilliBildirim.addTarget(self, action: #selector(stateChangedAkilliBildirim), for: .valueChanged)
        smsBildirim.addTarget(self, action: #selector(stateChangedSmsBildirim), for: .valueChanged)
  
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

  
    @objc func stateChangedServisDurumu(switchState: UISwitch) {
       if switchState.isOn {
        
        sendSeting(settingStatus: 1)
        print("bildirim durumu = acik ")
        UserDefaults.standard.ServisDurumuStatus = true
        sendSeting(settingStatus: 3)
        print("akilliBildirim durumu = acik ")
        akilliBildirim.isOn =  true
        UserDefaults.standard.akilliBildirimStatus = true
     
       } else {
        
        print("Servis  durumu = kapali ")
        print("anlikBildirim  durumu = kapali ")
        print("akilliBildirim  durumu = kapali ")
        sendSeting(settingStatus: 0)
        UserDefaults.standard.ServisDurumuStatus = false
        UserDefaults.standard.anlikBildirimStatus = false
        UserDefaults.standard.akilliBildirimStatus = false
        anlikBildirim.isOn =  false
        akilliBildirim.isOn =  false
       }
   }
    @objc func stateChangedAnlikBildirim(switchState: UISwitch) {
       if switchState.isOn {
        
        print("anlikBildirimStatus   = acik ")
        print("Servis   durumu = acik ")
        print("akilliBildirimStatus   = kapali ")
        
        sendSeting(settingStatus: 2)
        UserDefaults.standard.anlikBildirimStatus = true
        akilliBildirim.isOn =  false
        UserDefaults.standard.akilliBildirimStatus = false
      
        UserDefaults.standard.ServisDurumuStatus = true
        servisDurumu.isOn = true
       }
       else {
        print("akilliBildirim   = acik ")
        print("anlikBildirimStatus   = kapali ")
        
        akilliBildirim.isOn =  true
        sendSeting(settingStatus: 3)
        UserDefaults.standard.akilliBildirimStatus = true
        UserDefaults.standard.anlikBildirimStatus = false
       }
   }
    @objc func stateChangedAkilliBildirim(switchState: UISwitch) {
       if switchState.isOn {
        
        print("ServisDurumuStatus   = acik ")
        print("akilliBildirimStatus   = acik ")
        print("anlikBildirimStatus   = kapali ")
        
        sendSeting(settingStatus: 3)
        UserDefaults.standard.akilliBildirimStatus = true
        anlikBildirim.isOn =  false
        UserDefaults.standard.anlikBildirimStatus = false
        
        UserDefaults.standard.ServisDurumuStatus = true
        servisDurumu.isOn = true
       }
       else {
        
        print("anlikBildirim   = acik ")
        print("akilliBildirimStatus   = kapali ")
        
        anlikBildirim.isOn =  true
        sendSeting(settingStatus: 2)
        UserDefaults.standard.anlikBildirimStatus = true
        UserDefaults.standard.akilliBildirimStatus = false
       }
   }
    @objc func stateChangedSmsBildirim(switchState: UISwitch) {
       if switchState.isOn {
        sendSeting(settingStatus: 4)
        UserDefaults.standard.smsBildirimStatus = true
       } else {
        sendSeting(settingStatus: 5)
        UserDefaults.standard.smsBildirimStatus = false
       }
   }
    
    
    
    

        
        
    func sendSeting(settingStatus: Int) {
  
        guard let url = URL(string: "https://eftermo.com/mobil/apple/webayar.php") else {
                    return
                }
        print(settingStatus)
        let data : Data =  "gkod=\(UserDefaults.standard.accessToken!)&ayar=\(settingStatus)".data(using: .utf8)!
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
                    }
                })
                task.resume()
    
    
    }
    
    
 

}
