//
//  FirstViewController.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/8/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController {
    
    let singleton = Singleton.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Alamofire.request("http://testap.playone-sports.com/rest/game/listbyseason/4", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["accept": "txt/html,application/json"]).responseJSON { (response) in
            if response.result.isSuccess {
                if let jsonObj = response.value {
                    let json = JSON(jsonObj)
                    //                    print("playDate: \(json["1504281600000"][0]["playDate"].doubleValue)")
                    //                    print("playTime: \(json["1504281600000"][0]["playTime"].stringValue)")
                    //                    print("homeTeam: \(json["1504281600000"][0]["teamHome"]["name"].stringValue)")
                    //                    print("guestTeam: \(json["1504281600000"][0]["teamGuest"]["name"].stringValue)")
                    
                    
                    for i in 0..<8 {
                        self.singleton.dateIntervalArray.append(json["1504281600000"][i]["playDate"].doubleValue)
                        self.singleton.timeStringArray.append(json["1504281600000"][i]["playTime"].stringValue)
                        self.singleton.homeTeamStringArray.append(json["1504281600000"][i]["teamHome"]["name"].stringValue)
                        self.singleton.guestTeamStringArray.append(json["1504281600000"][i]["teamGuest"]["name"].stringValue)
                    }
                    
                    for j in 0..<8 {
                        self.singleton.dateIntervalArray.append(json["1505491200000"][j]["playDate"].doubleValue)
                        self.singleton.timeStringArray.append(json["1505491200000"][j]["playTime"].stringValue)
                        self.singleton.homeTeamStringArray.append(json["1505491200000"][j]["teamHome"]["name"].stringValue)
                        self.singleton.guestTeamStringArray.append(json["1505491200000"][j]["teamGuest"]["name"].stringValue)
                    }
                }
            } else {
                print("error: \(response.error!)")
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if singleton.dateIntervalArray.count != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            for i in 0..<singleton.dateIntervalArray.count {
                let tmpDate = Date.init(timeIntervalSince1970: singleton.dateIntervalArray[i] / 1000)
//                print(tmpDate)
                singleton.dateStringArray.append(dateFormatter.string(from: tmpDate))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
