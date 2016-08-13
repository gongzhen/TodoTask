//
//  CalendarYearViewDayCell.swift
//  Todo List
//
//  Created by gongzhen on 8/5/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CalendarYearViewDayCell: UICollectionViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var backView:UIView!
    
    override var selected : Bool {
        didSet {
            // self.layer.backgroundColor = (self.selected) ? UIColor.redColor().CGColor : UIColor.blueColor().CGColor
            self.label.backgroundColor = (self.selected) ? UIColor.redColor() : nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.font = UIFont.systemFontOfSize(9.0)
    }
    
    func config(text: NSAttributedString?) {
        self.label.attributedText = text
    }
}
