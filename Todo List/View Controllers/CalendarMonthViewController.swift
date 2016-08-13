//
//  CalendarMonthViewController.swift
//  Todo List
//
//  Created by gongzhen on 8/7/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CalendarMonthViewController: UIViewController {

    var selectedMonthIndex: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    var todoDict = [String: [AnyObject]]()
    
    private let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    private var calendarYearViewMonthDataSource: CalendarYearViewMonthDataSource!
    
    private let dateFormatter = NSDateFormatter()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TitlebarBG"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "CalendarMonthViewDayCell", bundle: nil), forCellWithReuseIdentifier: Constants.CalendarMonthViewDayCellIdentifier)
        collectionView.registerNib(UINib(nibName: "CalendarMonthViewHeaderYearView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.CalendarMonthViewHeaderYearViewIdentifier)
        collectionView.reloadData()
        
        let windowWidth: CGFloat = view.frame.size.width
        let itemsPerRow: CGFloat = 7.0
        let itemSpacing: CGFloat = 0.0
        let insetDistance: CGFloat = 10.0
        let itemWidth: CGFloat = (windowWidth - 2 * insetDistance) / itemsPerRow - itemSpacing
        let itemHeight: CGFloat = 60.0
        flowLayout.sectionInset = UIEdgeInsets(top: insetDistance, left: insetDistance, bottom: insetDistance, right: insetDistance)
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight) // 50 and 60
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.minimumLineSpacing = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //@todo re-initialize the todoDict.
        self.calendarYearViewMonthDataSource = CalendarYearViewMonthDataSource()
        self.calendarYearViewMonthDataSource.initTodos()
        self.todoDict = self.calendarYearViewMonthDataSource.todoDict
        // reload calendar to show todos.
        // reloadData will cause reuse cell to keep the old background color.
        // Fixed: setting selected property in custom cell.
        // credit: http://stackoverflow.com/questions/32015774/collection-view-reloaddata-method-shows-a-cell-as-selected
        self.collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.collectionViewLayout.prepareLayout()
        
        // collectionView ... frame.origin.y = (0, 0), (430, 0), (800, 0)
        // collectionView ... frame.origin = JAN(0, 0), FEB (0, 430), WED(0, 800)
        // collectionView ... frame = JAN: (0.0, 0.0, 375.0, 50.0)
        // collectionView ... frame = FEB: (0.0, 430.0, 375.0, 50.0)
        var offsetY: CGFloat = (collectionView.layoutAttributesForSupplementaryElementOfKind(
            UICollectionElementKindSectionHeader,
            atIndexPath: NSIndexPath(forItem: 0, inSection: selectedMonthIndex))?.frame.origin.y)!
        // offsetY: -64..366..736
        // selectedMonthIndex: 0, 1, 2, ... 11
        offsetY -= 64.0 // navigation bar height
        // print("frame y: \(collectionView.layoutAttributesForSupplementaryElementOfKind( UICollectionElementKindSectionHeader,atIndexPath: NSIndexPath(forItem: 0, inSection: selectedMonthIndex))?.frame)!")
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: offsetY), animated: false)
        
        // UIInterfaceOrientationIsLandscape change the collectionView frame from 375 to 716.
        // Modified the constraints in IB and force the width of frame is 375.
        // @todo: rewrite the constraint programmatically.
    }
}

extension CalendarMonthViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CalendarMonthViewDayCellIdentifier, forIndexPath: indexPath) as! CalendarMonthViewDayCell
        let month: Int = indexPath.section + 1
        let firstDayOfMonth: NSDate = firstDayInMonth(month)    // 2016 - MM - 01
        let firstWeekdayOfMonth: Int = weekdayForDate(firstDayOfMonth)  // 5
        let lastDayOfMonth: Int = lastDayInMonthFromStartOfMonth(firstDayOfMonth)   // 30
        if (indexPath.item < firstWeekdayOfMonth - 1 ||
            indexPath.item > lastDayOfMonth + firstWeekdayOfMonth - 2) {
            cell.hideDate()
            cell.hasTodos = false
        } else {
            cell.showDate()
            cell.dayLabel.text = "\(indexPath.item - firstWeekdayOfMonth + 2)"
            let monthString = month < 10 ? "0\(month)" : "\(month)"
            let dayString = ((indexPath.item - firstWeekdayOfMonth + 2)) < 10 ? "0\((indexPath.item - firstWeekdayOfMonth + 2))" : "\((indexPath.item - firstWeekdayOfMonth + 2))"
            let key = monthString + dayString
            // mark todo on the date.
            if let _ = self.todoDict[key] {
                cell.config(true, dotColor: UIColor.redColor())
                cell.selected = true
            }
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 * numberOfWeeksInMonth(section + 1)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let month: Int = indexPath.section + 1
            guard month >= 1 && month <= 12 else {
                assert(false, "Unexpected month")
            }
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier: Constants.CalendarMonthViewHeaderYearViewIdentifier,
                forIndexPath: indexPath) as! CalendarMonthViewHeaderYearView
            headerView.monthLabel.text = Constants.monthNames[month]
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension CalendarMonthViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CalendarMonthViewDayCell
        if cell.hasTodos == true {
            let calendarTodosTableViewController = CalendarTodosTableViewController()
            calendarTodosTableViewController.todoDict = self.todoDict

            let month: Int = indexPath.section + 1
            let firstDayOfMonth: NSDate = firstDayInMonth(month)
            let firstWeekdayOfMonth: Int = weekdayForDate(firstDayOfMonth)

            let monthString = month < 10 ? "0\(month)" : "\(month)"
            let dayString = ((indexPath.item - firstWeekdayOfMonth + 2)) < 10 ? "0\((indexPath.item - firstWeekdayOfMonth + 2))" : "\((indexPath.item - firstWeekdayOfMonth + 2))"
            calendarTodosTableViewController.key = monthString + dayString
            let navigationController = UINavigationController(rootViewController: calendarTodosTableViewController)
            // http://stackoverflow.com/questions/27326183/presenting-a-view-controller-programmatically-in-swift
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK - Private methods
extension CalendarMonthViewController {
    
    private func firstDayInMonth(month: Int) -> NSDate {
        // Use start with current year and month
        let components = calendar.components([.Year, .Month], fromDate: NSDate())
        
        // Manually set month
        components.month = month
        return calendar.dateFromComponents(components)!
    }
    
    private func lastDayInMonthFromStartOfMonth(startOfMonth: NSDate) -> Int {
        let components = NSDateComponents()
        components.month = 1
        components.day = -1
        let endOfMonth = calendar.dateByAddingComponents(components, toDate: startOfMonth, options: [])
        return calendar.component(NSCalendarUnit.Day, fromDate: endOfMonth!)
    }
    
    private func weekdayForDate(date: NSDate) -> Int {
        let components = calendar.components(.Weekday, fromDate: date)
        return components.weekday
    }
    
    private func numberOfWeeksInMonth(month: Int) -> Int {
        let components = calendar.components([.Year, .Month], fromDate: NSDate())
        components.month = month
        let weekRange = calendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: calendar.dateFromComponents(components)!)
        return weekRange.length
    }
}