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
