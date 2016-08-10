//
//  itemSelectCell.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class ItemSelectionCell: UITableViewCell {

    @IBOutlet weak var selectionFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(text: String, selected: Bool) -> ItemSelectionCell {
        self.textLabel?.text = text
        self.contentView.bringSubviewToFront(selectionFlag)
        setFlag(selected)
        return self
    }
    
    func setFlag(selected: Bool) -> ItemSelectionCell {
        if selected {
            selectionFlag.image = UIImage(named: Constants.SelectedImage)
        } else {
            selectionFlag.image = nil
        }
        return self
    }
}
