//
//  GuestAndHomeTeamViewController.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/8/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GRDB

class GuestAndHomeTeamViewController: UIViewController {

    @IBOutlet weak var homeTeamBtn: UIButton!
    @IBOutlet weak var guestTeamBtn: UIButton!
    let singleton = Singleton.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        homeTeamBtn.setTitle(singleton.tmpHomeTeamString, for: .normal)
        guestTeamBtn.setTitle(singleton.tmpGuestTeamString, for: .normal)
        
        checkIfTeamNameIsEqualToTeacherChicken(homeTeamBtn)
        checkIfTeamNameIsEqualToTeacherChicken(guestTeamBtn)
        
        
    }
    
    func goTeamInfo() {
        performSegue(withIdentifier: "goTeamInfo", sender: nil)
    }
    
    func checkIfTeamNameIsEqualToTeacherChicken(_ btn: UIButton) {
        if btn.titleLabel?.text == "雞老師好胖" {
            let playersController = try! FetchedRecordsController(dbQueue, request: Player.order(Column("jerseyNo").asc, Column("name")))
            try! playersController.performFetch()
            
            
            if playersController.sections[0].numberOfRecords == 0  {
                Alamofire.request("http://testap.playone-sports.com/rest/game/listrosters/234/151", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["accept": "txt/html,application/json"]).responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let jsonObj = response.value {
                            let json = JSON(jsonObj)
                            //                        print(json[0]["number"].stringValue)
                            //                        print(json[0]["roster"]["name"].stringValue)
                            for i in 0..<json.arrayObject!.count {
                                let tmpPlayer = Player.init(name: json[i]["roster"]["name"].stringValue, jerseyNo: Int(json[i]["number"].stringValue)!)
                                try! dbQueue.inDatabase { db in
                                    try tmpPlayer.save(db)
                                }
                            }
                        }
                    } else {
                        print("error: \(response.error!)")
                    }
                })
            }
            
            btn.addTarget(self, action: #selector(goTeamInfo), for: .touchUpInside)
            
            
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
