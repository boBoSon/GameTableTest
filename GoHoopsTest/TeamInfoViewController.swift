//
//  TeamInfoViewController.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/8/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import GRDB

class TeamInfoViewController: UIViewController, UITableViewDataSource {
    
    var tbl = UITableView.init()
    var playersController: FetchedRecordsController<Player>!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tbl.frame = view.frame
        tbl.dataSource = self
        tbl.register(UINib.init(nibName: "TeamInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamInfoTableViewCellIdentifier")
        view.addSubview(tbl)
        
        
        
        let request = playersSortedByJerseyNo
        playersController = try! FetchedRecordsController(dbQueue, request: request)
//        playersController.trackChanges(
//            willChange: { [unowned self] _ in
//                self.tbl.beginUpdates()
//            },
//            onChange: { [unowned self] (controller, record, change) in
//                switch change {
//                case .insertion(let indexPath):
//                    self.tbl.insertRows(at: [indexPath], with: .fade)
//                    
//                case .deletion(let indexPath):
//                    self.tbl.deleteRows(at: [indexPath], with: .fade)
//                    
//                case .update(let indexPath, _):
////                    if let cell = self.tbl.cellForRow(at: indexPath) {
////                        self.configure(cell, at: indexPath)
////                    }
//                    if let cell = self.tbl.cellForRow(at: indexPath) as? TeamInfoTableViewCell {
//                        self.configure(cell, at: indexPath)
//                    }
//                    
//                case .move(let indexPath, let newIndexPath, _):
//                    // Actually move cells around for more demo effect :-)
//                    let cell = self.tbl.cellForRow(at: indexPath) as? TeamInfoTableViewCell
//                    self.tbl.moveRow(at: indexPath, to: newIndexPath)
//                    if let cell = cell {
//                        self.configure(cell, at: newIndexPath)
//                    }
//                }
//            },
//            didChange: { [unowned self] _ in
//                self.tbl.endUpdates()
//        })
        try! playersController.performFetch()
        
        
        
        
        
        
        
        
    }
    
    // MARK: UITableViewDataSource
    
    func configure(_ cell: TeamInfoTableViewCell, at indexPath: IndexPath) {
        let player = playersController.record(at: indexPath)
        
        cell.playerNameLbl.text = player.name
        cell.jerseyNoLbl.text = "\(player.jerseyNo)"
        cell.jerseyNoTf.text = "\(player.jerseyNo)"
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playersController.sections[section].numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInfoTableViewCellIdentifier") as! TeamInfoTableViewCell
        
        configure(cell, at: indexPath)
        
        
        
        
        
        
        return cell
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

private let playersSortedByJerseyNo = Player.order(Column("jerseyNo").asc, Column("name"))
