//
//  CompletedTodosViewController.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CompletedTodosViewController: UITableViewController {

    let todoRepository = TodoRepository()
    var completedTodos: [Todo] = []
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Complete_Todo_Notification", object: nil)
    }
    
    lazy var noCompletedTodosView: UIImageView = {
        
        let tableWidth = CGRectGetWidth(self.tableView.frame)
        let tableHeight = CGRectGetHeight(self.tableView.frame) - (20 + 44 + 49)
        
        let view = UIImageView(image: UIImage(named: "No-Completed-Todo"))
        // let view = UIImageView(image: UIImage(named: "TitlebarBG"))
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        
        
        view.frame = CGRectMake((tableWidth - viewWidth) / 2.0, (tableHeight - viewHeight) / 2.0, viewWidth, viewHeight)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.removeExtraSeparators()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TitlebarBG"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        completedTodos = todoRepository.getCompletedTodos()
        if completedTodos.isEmpty {
            tableView.addSubview(noCompletedTodosView)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        completedTodos = todoRepository.getCompletedTodos()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTodos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CompletedTodoCell", forIndexPath: indexPath) as! TodoContentCell
        
        let todo = completedTodos[indexPath.row]
        cell.config(todo)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
 
            tableView.beginUpdates()
            let todo = self.completedTodos[indexPath.row]
            if let index = self.completedTodos.indexOf(todo) {
                self.completedTodos.removeAtIndex(index)
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.todoRepository.deleteTodo(todo)
            tableView.endUpdates()
        }
    }
}

extension CompletedTodosViewController: TodoContentCellProtocol {
    func updateTodoState(cell: TodoContentCell, completed: Bool) {
        let indexPath: NSIndexPath = tableView.indexPathForCell(cell)!
        let todo = completedTodos[indexPath.row]
        tableView.beginUpdates()
        todoRepository.recoverTodo(todo)
        if let index = completedTodos.indexOf(todo) {
            completedTodos.removeAtIndex(index)
        }
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)       
        tableView.endUpdates()
        print("completed state of todo \(todo.content) is \(todo.completed)")
    }
}
