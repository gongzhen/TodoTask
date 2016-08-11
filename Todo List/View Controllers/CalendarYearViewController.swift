//
//  CalendarYearViewController.swift
//  Todo List
//
//  Created by gongzhen on 8/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

import CoreData


class CalendarYearViewController: UIViewController {

    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let monthData: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var calendarYearViewMonthDataSource: CalendarYearViewMonthDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TitlebarBG"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        calendarYearViewMonthDataSource = CalendarYearViewMonthDataSource()
        calendarYearViewMonthDataSource.initTodos()
        
        self.yearCollectionView.dataSource = self
        self.yearCollectionView.delegate = self
        self.yearCollectionView.registerNib(
            UINib(nibName: Constants.nibNameCalendarYearViewMonthCell, bundle: nil), forCellWithReuseIdentifier: Constants.CalendarYearViewMonthCellIdentifier
        )        
        let windowWidth:CGFloat = self.view.frame.size.width
        let itemSpacing: CGFloat = 8.0
        let insetDistance: CGFloat = 20.0
        let itemWidth: CGFloat = (windowWidth - 2 * insetDistance) / 3.0 - itemSpacing
        self.flowLayout.sectionInset = UIEdgeInsets(
            top: insetDistance, left: insetDistance, bottom: insetDistance, right: insetDistance)
        self.flowLayout.itemSize = CGSizeMake(itemWidth, 128.0)
        self.flowLayout.minimumInteritemSpacing = itemSpacing
        self.flowLayout.minimumLineSpacing = 0
        
        self.title = "2016"
        self.yearCollectionView.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.redColor()
        //@todo: rewrite the constraints by code.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        calendarYearViewMonthDataSource.initTodos()
        self.yearCollectionView.reloadData()
    }
    
}

extension CalendarYearViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.yearCollectionView.dequeueReusableCellWithReuseIdentifier(
            Constants.CalendarYearViewMonthCellIdentifier, forIndexPath: indexPath) as! CalendarYearViewMonthCell
        let month: Int = self.monthData[indexPath.item]
        cell.monthLabel.text = "\(month)"
        cell.monthCollectionView.registerNib(
            UINib(nibName: Constants.nibNameCalendarYearViewDayCell, bundle: nil),
            forCellWithReuseIdentifier: Constants.CalendarYearViewDayCellIdentifier
        )

        cell.setCollectionViewDataSourceDelegate(calendarYearViewMonthDataSource, forMonth: month)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 12 months for numberOfItems in Section.
        return self.monthData.count
    }
}

extension CalendarYearViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // image: phase 6-1 and phase 6-2
        let calendarMonthViewController = CalendarMonthViewController()
        calendarMonthViewController.selectedMonthIndex = indexPath.item
        calendarMonthViewController.currentMonth = DateUtils.getCurrentMonth()
        calendarMonthViewController.currentDay = DateUtils.getCurrentDay()
        calendarMonthViewController.todoDict = self.calendarYearViewMonthDataSource.todoDict
        // self.presentViewController(calendarMonthViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(calendarMonthViewController, animated: true)
    }
}
