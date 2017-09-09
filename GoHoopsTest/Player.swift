//
//  Player.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/9/9.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import GRDB

class Player: Record {
    var id: Int64?
    var name: String
    var jerseyNo: Int
    
    init(name: String, jerseyNo: Int) {
        self.name = name
        self.jerseyNo = jerseyNo
        super.init()
    }
    
    // MARK: Record overrides
    
    /// The table name
    override class var databaseTableName: String {
        return "players"
    }
    
    /// Initialize from a database row
    required init(row: Row) {
        id = row.value(named: "id")
        name = row.value(named: "name")
        jerseyNo = row.value(named: "jerseyNo")
        super.init(row: row)
    }
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["name"] = name
        container["jerseyNo"] = jerseyNo
    }
    
    /// Update person id after successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }

}
