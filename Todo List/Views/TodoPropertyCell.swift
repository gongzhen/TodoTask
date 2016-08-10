//
//  TodoPropertyCell.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class TodoPropertyCell: UITableViewCell {

    func config(imagePath: String, label: String, text: String?) -> TodoPropertyCell {
        self.detailTextLabel?.text = text
        self.imageView?.image = UIImage(named: imagePath)
        self.textLabel?.text = label
        
        return self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
