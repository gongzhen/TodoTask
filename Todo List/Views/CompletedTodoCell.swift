//
//  CompletedTodoCell.swift
//  Todo List
//
//  Created by gongzhen on 8/3/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CompletedTodoCell: TodoContentCell {

    @IBOutlet weak var todolistContent: UILabel!
    @IBOutlet weak var completedTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction override func flipTodo(sender: UIButton) {
        self.completedFlag.selected = !self.completedFlag.selected
        setStrikethroughStyle(completedFlag.selected)
        self.delegate.updateTodoState(self, completed: self.completedFlag.selected)
    }
    
    override func config(todo: Todo) {
        content.text = todo.content
        todolistContent.text = todo.todolist?.content
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        completedTime.text = dateFormatter.stringFromDate(todo.completedTime!)
    }
}
