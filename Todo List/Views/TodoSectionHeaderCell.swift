//
//  TodoSectionHeaderCell.swift
//  Todo List
//
//  Created by gongzhen on 7/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class TodoSectionHeaderCell: UITableViewHeaderFooterView {
    
    var sectionHeaderLabel: UILabel
    var sectionNumberTodos: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not support")
    }
    
    override init(reuseIdentifier: String?) {
        sectionHeaderLabel = UILabel(frame: CGRect.null)
        sectionHeaderLabel.textColor = UIColor.blackColor()
        sectionHeaderLabel.font = UIFont.boldSystemFontOfSize(16)
        
        sectionNumberTodos = UILabel(frame: CGRect.null)
        sectionNumberTodos.textColor = UIColor.blackColor()
        sectionNumberTodos.font = UIFont.boldSystemFontOfSize(16)
        sectionNumberTodos.textAlignment = .Left
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubview(sectionHeaderLabel)
        self.addSubview(sectionNumberTodos)
    }
    
    override func layoutSubviews() {
        // set constraints
        sectionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionNumberTodos.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary = ["sectionHeaderLabel":sectionHeaderLabel, "sectionNumberTodos": sectionNumberTodos]
        let headerlabel_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[sectionHeaderLabel(>=100)]", // A keyword surrounded by square brackets [] is a view, in parentheses () is the size of the view.
            // H:[view1(50)]" means we want a 50 point wide view.
            options: NSLayoutFormatOptions.AlignAllCenterY, // By setting the initializer to rawValue:0,
            // we tell teh compiler we are doing nothing here.
            metrics: nil, //
            views: viewsDictionary
        )
        
        let numberlabel_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[sectionNumberTodos]-10-|", // A keyword surrounded by square brackets [] is a view, in parentheses () is the size of the view.
            // H:[view1(50)]" means we want a 50 point wide view.
            options: NSLayoutFormatOptions.AlignAllCenterY, // By setting the initializer to rawValue:0,
            // we tell teh compiler we are doing nothing here.
            metrics: nil, //
            views: viewsDictionary
        )
        
        let sectionlabel_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[sectionHeaderLabel]-|", // vertically lays out button1 STANDARD WIDTH from the bottom of the superview with a height of STANDARD WIDTH.
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil,
            views: viewsDictionary
        )
        
        let numberlabel_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[sectionNumberTodos]-|", // vertically lays out button1 STANDARD WIDTH from the bottom of the superview with a height of STANDARD WIDTH.
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil,
            views: viewsDictionary
        )
        
        self.contentView.backgroundColor = UIColor.greenColor()
        
        self.addConstraints(headerlabel_constraint_H)
        self.addConstraints(numberlabel_constraint_H)
        self.addConstraints(sectionlabel_constraint_V)
        self.addConstraints(numberlabel_constraint_V)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizerShouldBegin")
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(headerText: String, numberText: String) {
        self.sectionHeaderLabel.text = headerText
        self.sectionNumberTodos.text = numberText
    }
}
