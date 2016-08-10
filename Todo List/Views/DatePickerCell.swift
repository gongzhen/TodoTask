//
//  DatePickerCell.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate {
    func dateChanged(date: NSDate)
}

class DatePickerCell: UITableViewCell {
    
    var delegate: DatePickerCellDelegate?    
    
    @IBOutlet weak var pickerView: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set up pickerView constrant programmatically.
        configView()
        self.pickerView.addTarget(self, action: #selector(dateDidChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configView() {
        self.pickerView.frame = CGRectMake(0, 9, 600, 162)
    }
    
    func dateDidChanged() {
        self.delegate?.dateChanged(pickerView.date)
    }
    
}
