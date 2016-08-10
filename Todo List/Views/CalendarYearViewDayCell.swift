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
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("NSCoding not supported")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // self.label.frame: (0.0, 0.0, 46.0, 16.0)
//        self.label = UILabel(frame: CGRect.null)
//        self.label.textAlignment = .Center
//
//        self.backgroundColor = UIColor.blueColor()
//        self.addSubview(self.label)
//    }
    
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
