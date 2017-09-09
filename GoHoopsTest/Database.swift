//
//  Database.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/9/9.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import GRDB

// The shared database queue.
var dbQueue: DatabaseQueue!

func setupDatabase(_ application: UIApplication) throws {
    
    // Connect to the database
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let databasePath = documentsPath.appendingPathComponent("db.sqlite")
    dbQueue = try DatabaseQueue(path: databasePath)
    
    
    // Be a nice iOS citizen, and don't consume too much memory
    
    dbQueue.setupMemoryManagement(in: application)
    
    
    // Use DatabaseMigrator to setup the database
    
    var migrator = DatabaseMigrator()
    
    migrator.registerMigration("CreatePlayersTable") { db in
        // Compare person names in a localized case insensitive fashion
        // See https://github.com/groue/GRDB.swift/#unicode
        try db.create(table: "players") { t in
            t.column("id", .integer).primaryKey()
            t.column("name", .text).notNull().collate(.localizedCaseInsensitiveCompare)
            t.column("jerseyNo", .integer).notNull()
        }
    }
    
//    migrator.registerMigration("InitialPersons") { db in
//        try Person(name: "Arthur", score: 250).insert(db)
//        try Person(name: "Barbara", score: 750).insert(db)
//        try Person(name: "Craig", score: 500).insert(db)
//    }
    
    try migrator.migrate(dbQueue)
}


