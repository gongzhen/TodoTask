//
//  Constants.swift
//  Todo List
//
//  Created by gongzhen on 7/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: UITable View Cell Identifier
    
    static let TodoContentCell = "TodoContentCell"
    static let TodoContentEditingCell = "TodoContentEditingCell"
    static let TodoPropertyCell = "TodoPropertyCell"
    static let DatePickerCell = "DatePickerCell"
    static let ItemSelectionCellNib = "ItemSelectionCell"
    static let ItemSelectionCellID = "ItemSelectionCell"
    
    // MARK: Storyboard Identifier
    
    static let TodoDetailsSegueID = "TodoDetailSegue"
    static let AddTodoSegueID = "AddTodoSegue"
    static let CancelUnwindSegueID = "cancelUnwindSegue"
    static let SaveUnwindSegueID = "saveUnwindSegue"
    static let TodosViewControllerID = "todosViewControllerID"

    
    // MARK: Image View Name
    static let TodoDateImage = "Cell-Date"
    static let TodoGroupImage = "Cell-Group"
    static let SelectedImage = "Check-Green"
    
    // MARK: Date Label
    static let TodoDateLabel = "Date"
    static let TodoGroupLabel = "Group"
    
    // MARK: UICollection View Cell Identifier
    static let CalendarYearViewMonthCellIdentifier = "calendarYearViewMonthCell"
    static let nibNameCalendarYearViewMonthCell = "CalendarYearViewMonthCell"
    
    static let CalendarYearViewDayCellIdentifier = "calendarYearViewDayCell"
    static let nibNameCalendarYearViewDayCell = "CalendarYearViewDayCell"
    
    static let CalendarMonthViewDayCellIdentifier = "calendarMonthViewDayCellIdentifier"
    static let CalendarMonthViewHeaderYearViewIdentifier = "calendarMonthViewHeaderYearViewIdentifier"
    
    static let monthNames: [Int:String] = [
        1: "JAN",
        2: "FEB",
        3: "MAR",
        4: "APR",
        5: "MAY",
        6: "JUN",
        7: "JUL",
        8: "AUG",
        9: "SEP",
        10: "OCT",
        11: "NOV",
        12: "DEC"
    ]
    
    
    
}