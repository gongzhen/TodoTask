//
//  TodoContentEditingCell.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class TodoContentEditingCell: UITableViewCell {

    @IBOutlet weak var content: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.content.setTextPadding(15)
    }
    
}
