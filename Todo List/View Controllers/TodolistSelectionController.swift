//
//  TodolistSelectionController.swift
//  Todo List
//
//  Created by gongzhen on 7/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

@objc protocol ItemSelectionControllerDelegate {
    func todolistContent(item: AnyObject) -> String?
    func todolistSelected(item: AnyObject)
}

class TodolistSelectionController: UITableViewController {

    var todolistsForSelection = []
    var selectedItem: AnyObject?
    var delegate:ItemSelectionControllerDelegate!
    var indexPathOfSelectedItem: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: Constants.ItemSelectionCellNib, bundle: nil), forCellReuseIdentifier: Constants.ItemSelectionCellID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolistsForSelection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.ItemSelectionCellID, forIndexPath: indexPath) as! ItemSelectionCell
        let todolist: AnyObject = todolistsForSelection[indexPath.row]
        
        if let content = delegate.todolistContent(todolist) {
            if todolist === selectedItem {
                cell.config(content, selected: true)
                indexPathOfSelectedItem = indexPath
            } else {
                cell.config(content, selected: false)
            }
        }
        cell.imageView?.image = UIImage(named: Constants.TodoGroupImage)
        return cell
    }
}

// MARK: - Table view delegate

extension TodolistSelectionController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ItemSelectionCell
        let todolist = todolistsForSelection[indexPath.row] as! Todolist
        
        if selectedItem !== todolist {
            print("didSelectRowAtIndexPath: \(indexPath.row) and \(todolist.content!)")
            cell.setFlag(true)
            
            if let indexPathOfSelectedItem = indexPathOfSelectedItem {
                let selectedCell = tableView.dequeueReusableCellWithIdentifier(Constants.ItemSelectionCellID, forIndexPath: indexPathOfSelectedItem) as! ItemSelectionCell
                print("didSelectRowAtIndexPath: \(indexPathOfSelectedItem.row)")
                selectedCell.setFlag(false)
                print("\(selectedCell.selectionFlag.image)")
            }
            
            // cell.config(todolist.content!, selected: true)
            // todoRepository move the selected todolist and update the todo.
            // Or I can create the delegate method to update the todo.
            self.delegate.todolistSelected(todolist)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
}

