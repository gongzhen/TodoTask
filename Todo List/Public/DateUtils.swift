
//
//  DateUtils.swift
//  Todo List
//
//  Created by gongzhen on 7/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation

class DateUtils {
    
    struct Constants {
        static let Seconds_Per_Day = 86400.0
        static let Days_Per_Week = 7.0
        
        static let Today = "Today"
        static let Tomorrow = "Tomorrow"
        static let Undefined = "Not Decide"
    }
    
    class func removeTimePart(date: NSDate) -> NSDate? {
        let calendarUnit : NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year]
        let dateComponent = NSCalendar.currentCalendar().components(calendarUnit, fromDate: date)
        /** 
         dateComponent:
         <NSDateComponents: 0x7f89dbcb40e0>
         Calendar Year: 2016
         Month: 8
         Leap month: no
         Day: 3
         */
        return NSCalendar.currentCalendar().dateFromComponents(dateComponent)
    }
    
    class func today() -> NSDate {
        return DateUtils.removeTimePart(NSDate())!
    }
    
    class func tomorrow() -> NSDate {
        return DateUtils.removeTimePart(NSDate().dateByAddingTimeInterval(Constants.Seconds_Per_Day))!
    }
    
    class func representationTextOfDate(theDate: NSDate?) -> String {
        
        if let date = theDate {
            
            if (DateUtils.removeTimePart(date)?.compare(DateUtils.today()) == NSComparisonResult.OrderedSame) {
                return Constants.Today
            } else if (DateUtils.removeTimePart(date)?.compare(DateUtils.tomorrow()) == NSComparisonResult.OrderedSame) {
                return Constants.Tomorrow
            } else {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd"
                return dateFormatter.stringFromDate(date)
            }
        }
        
        return Constants.Undefined
    }
    
    class func getCurrentDay() -> Int {
        let calendarUnit: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year]
        let componets = NSCalendar.currentCalendar().components(calendarUnit, fromDate: NSDate())
        return componets.day
    }
    
    class func getCurrentMonth() -> Int {
        let calendarUnit: NSCalendarUnit = [NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year]
        let componets = NSCalendar.currentCalendar().components(calendarUnit, fromDate: NSDate())
        return componets.month
    }
}