//
//  TodoContentCell.swift
//  Todo List
//
//  Created by gongzhen on 7/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

protocol TodoContentCellProtocol {
    func updateTodoState(cell: TodoContentCell, completed: Bool)
}

class TodoContentCell: UITableViewCell {

    @IBOutlet weak var completedFlag: UIButton!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    var delegate: TodoContentCellProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func flipTodo(sender: UIButton) {
        self.completedFlag.selected = !self.completedFlag.selected
        setStrikethroughStyle(self.completedFlag.selected)
        self.delegate.updateTodoState(self, completed: self.completedFlag.selected)
    }
    
    func setStrikethroughStyle(selected: Bool) {
        var textAttributes = [:]
        if selected == true {
            textAttributes = [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            // NSNumber containing integer, default 0: no strikethrough
        }
        self.content.attributedText = NSMutableAttributedString(string: self.content.text!, attributes: textAttributes as? [String: AnyObject])
    }
    
    func config(todo: Todo){
        self.content.text = todo.content
        self.completedFlag.selected = todo.completed!.boolValue
        self.setStrikethroughStyle(todo.completed!.boolValue)
        self.dueDate.text = DateUtils.representationTextOfDate(todo.dueDate)        
    }
}
