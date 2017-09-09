//
//  Singleton.swift
//  GoHoopsTest
//
//  Created by 邱柏盛 on 2017/8/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    static let standard = Singleton()
    
    
    
    var tmpHomeTeamString: String!
    var tmpGuestTeamString: String!
    
    var dateIntervalArray = [Double]()
    var timeStringArray = [String]()
    var homeTeamStringArray = [String]()
    var guestTeamStringArray = [String]()
    
    var dateStringArray = [String]()
    
    
    
    
    
    
    
    
    private override init() {
        super.init()
    }
}
