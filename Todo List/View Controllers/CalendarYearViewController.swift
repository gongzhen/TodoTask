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
        
//        self.yearCollectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        let yearCollectionViewConstraintTrailing = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Trailing,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.Trailing,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//        // http://stackoverflow.com/questions/15365286/adding-priority-to-layout-constraints
//        yearCollectionViewConstraintTrailing.priority = 1000
//        self.view.addConstraint(yearCollectionViewConstraintTrailing)
//
//        let yearCollectionViewConstraintLeading = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Leading,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.Leading,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//        yearCollectionViewConstraintLeading.priority = 1000
//        self.view.addConstraint(yearCollectionViewConstraintLeading)
//        
//        let yearCollectionViewConstraintTop = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.topLayoutGuide,
//            attribute: NSLayoutAttribute.Bottom,
//            multiplier: 1.0,
//            constant: 64.0
//        )
//        yearCollectionViewConstraintTop.priority = 1000
//        self.view.addConstraint(yearCollectionViewConstraintTop)
//        
//        let yearCollectionViewConstraintBottom = NSLayoutConstraint(
//            item: self.bottomLayoutGuide,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Bottom,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//        yearCollectionViewConstraintBottom.priority = 1000
//        self.view.addConstraint(yearCollectionViewConstraintBottom)      
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

        // cell.monthCollectionView.registerClass(
        // CalendarYearViewDayCell.self, forCellWithReuseIdentifier: Constants.CalendarYearViewDayCellIdentifier)
        // cell's monthCollectionView will be signed delegate and datasource.
        // cell will be iterated 12 times.
        // month from 1 to 12.
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


// The code below trys to write the UICollectionView programmatically.
// @todo: rewrite uicollection programmatically.
// http://stackoverflow.com/questions/37532146/programmatically-defined-constraints-swift-ios
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let windowWidth:CGFloat = self.view.frame.size.width    // 414
//        let itemSpacing: CGFloat = 8.0
//        let insetDistance: CGFloat = 20.0
//        let itemWidth: CGFloat = (windowWidth - 2 * insetDistance) / 3.0 - itemSpacing // 116
//        self.flowLayout = UICollectionViewFlowLayout()
//        // The margins used to lay out content in a section
//        self.flowLayout.sectionInset = UIEdgeInsets(top: insetDistance, left: insetDistance, bottom: insetDistance, right: insetDistance)
//
//        self.flowLayout.itemSize = CGSizeMake(itemWidth, 128.0)
//        self.flowLayout.minimumInteritemSpacing = itemSpacing
//        self.flowLayout.minimumLineSpacing = 0
//
//        self.yearCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.flowLayout)
//        self.yearCollectionView.dataSource = self
//        self.yearCollectionView.delegate = self
//        self.yearCollectionView.registerClass(CalendarYearViewMonthCell.self, forCellWithReuseIdentifier: Constants.CalendarYearViewMonthCellIdentifier)
//
//        self.title = "2016"
//        self.yearCollectionView.backgroundColor = UIColor.cyanColor()
//        self.navigationController?.navigationBar.tintColor = UIColor.redColor()
//        self.view.addSubview(self.yearCollectionView)
//
//        self.yearCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        // self.yearCollectionView.removeConstraints(self.yearCollectionView.constraints)
//        let yearCollectionViewConstraintTop = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Top,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.Top,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//        let yearCollectionViewConstraintLeading = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Leading,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.Leading,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//        let yearCollectionViewConstraintTrailing = NSLayoutConstraint(
//            item: self.yearCollectionView,
//            attribute: NSLayoutAttribute.Trailing,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.Trailing,
//            multiplier: 1.0,
//            constant: 0.0
//        )
//
//        self.view.addConstraints([yearCollectionViewConstraintTop, yearCollectionViewConstraintLeading, yearCollectionViewConstraintTrailing])
//
////        let viewsDictionary = ["yearCollectionView": yearCollectionView]
////        let yearCollectionViewConstraints_H = NSLayoutConstraint.constraintsWithVisualFormat(
////            "H:[yearCollectionView]-|",
////            options:NSLayoutFormatOptions(rawValue: 0),
////            metrics: nil,
////            views: viewsDictionary
////        )
////        let yearCollectionViewConstraints_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[yearCollectionView]-|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: viewsDictionary)
////
////        self.view.addConstraints(yearCollectionViewConstraints_H)
////        self.view.addConstraints(yearCollectionViewConstraints_V)
//        print(self.view)
//        print(self.yearCollectionView)
//        print(self.flowLayout)
//
//    }
