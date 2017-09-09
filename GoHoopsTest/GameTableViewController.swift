//
//  GameTableViewController.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/8/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GameTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tbl: UITableView!
    let singleton = Singleton.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        Alamofire.request("http://testap.playone-sports.com/rest/game/listbyseason/4").responseData { (response) in
//            if response.result.isSuccess {
//                if let result = response.value as? [String: String] {
//                    dateIntervalArray.append(result["1502467200000"]!["playDate"]!)
//                    if let secondLayer = result["1502467200000"] as? [String: String] {
//                        
//                    }
//                }
                
//                if let jsonObj = response.value {
//                    let json = JSON(jsonObj)
//                    print("playerDate: \(json["1504281600000"][0]["playTime"].string)")
//                }
//                print(response.result.value)
//                if let jsonObj = response.value {
//                    let json = JSON.init(data: jsonObj)
//                    print("playerDate: \(json["1504281600000"])")
//                }
//                
//                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)")
//                }
                
//            } else {
//                print("error: \(response.error!)")
//            }
//        }
        
//        let parameters = Parameters()
//        Alamofire.request("http://testap.playone-sports.com/rest/game/listbyseason/4", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
//            print("response does exit")
//            if let result = response.result.value {
//                
//            } else {
//                print("error: \(response.error!)")
//            }
//        }
//        timeStringArray.append("2017/09/02 13:00")
//        homeTeamStringArray.append("Power Rangers")
//        guestTeamStringArray.append("雞老師好胖")
        
//        Alamofire.request("http://testap.playone-sports.com/rest/game/listbyseason/4", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["accept": "txt/html,application/json"]).responseJSON { (response) in
//            if response.result.isSuccess {
//                if let jsonObj = response.value {
//                    let json = JSON(jsonObj)
////                    print("playDate: \(json["1504281600000"][0]["playDate"].doubleValue)")
////                    print("playTime: \(json["1504281600000"][0]["playTime"].stringValue)")
////                    print("homeTeam: \(json["1504281600000"][0]["teamHome"]["name"].stringValue)")
////                    print("guestTeam: \(json["1504281600000"][0]["teamGuest"]["name"].stringValue)")
//                    for i in 0..<8 {
//                        self.dateIntervalArray.append(json["1504281600000"][i]["playDate"].doubleValue)
//                        self.timeStringArray.append(json["1504281600000"][i]["playTime"].stringValue)
//                        self.homeTeamStringArray.append(json["1504281600000"][i]["teamHome"]["name"].stringValue)
//                        self.guestTeamStringArray.append(json["1504281600000"][i]["teamGuest"]["name"].stringValue)
//                    }
//                    
//                    for j in 0..<8 {
//                        self.dateIntervalArray.append(json["1504886400000"][j]["playDate"].doubleValue)
//                        self.timeStringArray.append(json["1504886400000"][j]["playTime"].stringValue)
//                        self.homeTeamStringArray.append(json["1504886400000"][j]["teamHome"]["name"].stringValue)
//                        self.guestTeamStringArray.append(json["1504886400000"][j]["teamGuest"]["name"].stringValue)
//                    }
//                }
//            } else {
//                print("error: \(response.error!)")
//            }
//        }
        
        
        
        
        
        tbl = UITableView.init(frame: view.frame)
        
        tbl.delegate = self
        tbl.dataSource = self
        
        tbl.register(UINib.init(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCellIdentifier")
        view.addSubview(tbl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    // MARK: UITableViewDataSource
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleton.homeTeamStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCellIdentifier") as! GameTableViewCell
        cell.dateLbl.text = singleton.dateStringArray[indexPath.row]
        cell.timeLbl.text = singleton.timeStringArray[indexPath.row]
        cell.homeLbl.text = singleton.homeTeamStringArray[indexPath.row]
        cell.guestLbl.text = singleton.guestTeamStringArray[indexPath.row]
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tmpCell = tableView.cellForRow(at: indexPath) as! GameTableViewCell
        singleton.tmpHomeTeamString = tmpCell.homeLbl.text
        singleton.tmpGuestTeamString = tmpCell.guestLbl.text
        
        performSegue(withIdentifier: "goGuestAndHome", sender: nil)
    }

}
