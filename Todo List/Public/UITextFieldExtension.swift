//
//  UITextField.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setTextPadding(x: CGFloat) {
        setTextLeftPadding(x)
        setTextRightPadding(x)
    }
    
    func setTextLeftPadding(x: CGFloat) {
        self.leftView = UIView(frame: CGRectMake(0, 0, x, self.frame.size.height))
        self.leftViewMode = UITextFieldViewMode.Always
    }
    
    func setTextRightPadding(x: CGFloat) {
        self.rightView = UIView(frame: CGRectMake(0, 0, x, self.frame.size.height))
        self.rightViewMode = UITextFieldViewMode.Always
    }
}