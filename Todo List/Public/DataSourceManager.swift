//
//  DataSourceManager.swift
//  Todo List
//
//  Created by gongzhen on 8/5/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation

class DataSourceManager {

    var todos:[AnyObject]?
    
    class func sharedInstance() -> DataSourceManager {
        struct Static {
            static let instance = DataSourceManager()
        }
        return Static.instance
    }
}