//
//  CalendarYearViewMonthCell.swift
//  Todo List
//
//  Created by gongzhen on 8/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

// CalendarYearViewMonthCell will contains a month collection.
// Each cell will be one of months in a year.
// 
class CalendarYearViewMonthCell: UICollectionViewCell {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var monthLabel:UILabel!
    // monthCollectionView for each month.
    @IBOutlet weak var monthCollectionView:UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.monthCollectionView.backgroundColor = UIColor.clearColor()
        
        self.monthCollectionView.userInteractionEnabled = false
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.minimumInteritemSpacing = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemWidth = floor(monthCollectionView.bounds.size.width / 7.0)
        // print("itemWidth: \(itemWidth)")
        self.flowLayout.itemSize = CGSizeMake(itemWidth, 16.0) // itemWidth 46
    }
    
    func setCollectionViewDataSourceDelegate<D where D: UICollectionViewDataSource, D: UICollectionViewDelegate>(datasourceDelegate: D, forMonth month: Int) {
        self.monthCollectionView.dataSource = datasourceDelegate
        self.monthCollectionView.delegate = datasourceDelegate
        self.monthCollectionView.tag = month
        self.monthCollectionView.reloadData()    
    }
        
}
