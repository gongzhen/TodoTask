//
//  CalendarMonthViewDayCell.swift
//  Todo List
//
//  Created by gongzhen on 8/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CalendarMonthViewDayCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    var hasTodos:Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func hideDate() {
        dayLabel.hidden = true
        dotView.hidden = true
    }
    
    func hideDotView() {
        dotView.hidden = true
    }
    
    func showDate() {
        dayLabel.hidden = false
        dotView.hidden = false
    }
    
    func config(hasTodos: Bool, dotColor:UIColor?){
        self.hasTodos = hasTodos
        self.dotView.backgroundColor = dotColor
    }
    
}
