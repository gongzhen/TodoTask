//
//  CalendarYearViewMonthDataSource.swift
//  Todo List
//
//  Created by gongzhen on 8/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

// 
// CalendarYearViewMonthDataSource: it will be iterate 12 times.
// Each time it has one SECTION. 
// Each section is one month. It will display 30 or 31 days.
class CalendarYearViewMonthDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    var todos:[Todo]? = []
    var todoDict = [String: [AnyObject]]()
    
    func initTodos() {
        self.todoDict = [String: [AnyObject]]()
        self.todos = DataSourceManager.sharedInstance().todos as? [Todo]
        if let todos = todos {
            for todo in todos {
                if let dueDate = todo.dueDate {
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let dateString = dateFormatter.stringFromDate(dueDate)
                    let token:[String] = dateString.characters.split{$0 == "-"}.map(String.init)
                    let key = "\(token[0])\(token[1])"
                    if todoDict[key] != nil {
                        todoDict[key]?.append(todo)
                    } else {
                        todoDict[key] = [todo]
                    }
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CalendarYearViewDayCellIdentifier, forIndexPath: indexPath) as! CalendarYearViewDayCell
        let month: Int = collectionView.tag
        let firstDayOfMonth: NSDate = firstDayInMonth(month)
        let firstWeekdayOfMonth: Int = weekdayForDate(firstDayOfMonth)
        let lastDayOfMonth: Int = lastDayInMonthFromStartOfMonth(firstDayOfMonth)
        
        // print("indexPath: \(indexPath.item)")
        // firstWeekdayOfMonth = 6, lastDayOfMonth = 30 or 31
        if indexPath.item < firstWeekdayOfMonth - 1
            || indexPath.item > lastDayOfMonth + firstWeekdayOfMonth - 2 {
            cell.label.text = ""
        } else {
            cell.label.text = "\(indexPath.item - firstWeekdayOfMonth + 2)"
            cell.label.textAlignment = .Center
            // if month equals the month and day equals the day.
            let monthString = month < 10 ? "0\(month)" : "\(month)"
            let dayString = ((indexPath.item - firstWeekdayOfMonth + 2)) < 10 ? "0\((indexPath.item - firstWeekdayOfMonth + 2))" : "\((indexPath.item - firstWeekdayOfMonth + 2))"
            let key = monthString + dayString
            if let _ = self.todoDict[key] {
                let underLineAttributes = [
                    NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleDouble.rawValue,
                    NSUnderlineColorAttributeName: UIColor.redColor()]
                let underLineString = NSAttributedString(string: cell.label.text!, attributes: underLineAttributes)
                cell.selected = true                
                cell.config(underLineString)
            }            
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * numberOfWeeksInMonth(section + 1)
    }
    
    // MARK: - Private Methods
    // month: 1
    // output: weekRange(1, 6) and weekRange.length 6
    // @todo: figure out how this rangeOfUnit work.
    private func numberOfWeeksInMonth(month: Int) -> Int {
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
        components.month = month
        // print("month: \(month)")
        let weekRange = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: calendar.dateFromComponents(components)!)
        // print("weekRange: \(weekRange)")
        // print("weekRange: \(weekRange.length)")
        return weekRange.length
    }
    
    // firstDayInMonth
    // output: 2016-12-01 08:00:00 +0000, 2016-11-01 07:00:00 +0000 ... 2016-01-01 08:00:00 +0000
    private func firstDayInMonth(month: Int) -> NSDate {
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
        components.month = month
        // print("firstDayInMonth: \(calendar.dateFromComponents(components)!)")
        return calendar.dateFromComponents(components)!
    }
    
    // return: Weekday: 6
    private func weekdayForDate(date: NSDate) -> Int {
        //@bug fixed: parameter: fromDate should be date not NSDate()
        let components = calendar.components(.Weekday, fromDate: date)
        // print("weekdayForDate:")
        // print(components)
        return components.weekday
    }
    
    // endOfMonth: 2016-01-31 08:00:00 +0000 ... 2016-12-31 08:00:00 +0000
    // calendar.component(NSCalendarUnit.Day, fromDate: endOfMonth!): 31 or 30 or 29 or 28
    private func lastDayInMonthFromStartOfMonth(startOfMonth: NSDate) -> Int {
        let components = NSDateComponents()
        components.month = 1
        components.day = -1
        // options : NSCalendarOptions
        let endOfMonth = calendar.dateByAddingComponents(components, toDate: startOfMonth, options: [])
        // print("lastDayInMonthFromStartOfMonth: \(endOfMonth)")
        // print("lastDayInMonthFromStartOfMonth:")
        // print(calendar.component(NSCalendarUnit.Day, fromDate: endOfMonth!))
        return calendar.component(NSCalendarUnit.Day, fromDate: endOfMonth!)
    }
}
