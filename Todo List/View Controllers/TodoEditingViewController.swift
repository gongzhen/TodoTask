//
//  TodoEditingViewController.swift
//  Todo List
//
//  Created by gongzhen on 7/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit
import CoreData

class TodoEditingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todo: Todo!
    var createNewCell = false
    var hasDatePicker = false
    let todoRepository = TodoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TitlebarBG"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        if createNewCell == true {
            self.todo = todoRepository.createNewTodo()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TodoContentEditingCell
        guard cell.content.text != ""  else {            
            if identifier == Constants.CancelUnwindSegueID {
                return true
            }
            // text == "" && identifier != cancel.
            let alert = UIAlertController(title: "Empty Content", message: "Please input the text", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        //identifier
        return true
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.SaveUnwindSegueID {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TodoContentEditingCell

            self.todo.content = cell.content.text
            CoreDataStackManager.sharedInstance().saveContext()
            print("EditingViewController segue")
            // todoRepository.printTodos()
        } else if segue.identifier == Constants.CancelUnwindSegueID {
            if createNewCell == true {
                todoRepository.deleteTodo(self.todo)
            }
        }
    }
}

extension TodoEditingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return isDatePickerIndexPath(indexPath) ? 180.0 : 44.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /// http://stackoverflow.com/questions/27449590/correctly-returning-uiview-in-viewforheaderinsection-ios-8-swift
        if(section == 0) {
            let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
            let label = UILabel()
            label.text="Add New Task"
            label.translatesAutoresizingMaskIntoConstraints = false
            let views = ["label": label, "view": view]
            view.addSubview(label)
            let horizontallayoutContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: .AlignAllCenterX, metrics: nil, views: views)
            view.addConstraints(horizontallayoutContraints)
            let verticallayoutContraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
            view.addConstraint(verticallayoutContraint)
            return view
        }
        return nil
    }
}

extension TodoEditingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasDatePicker {
            return 4
        }
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.row {
        case 0:
            /* display cell with content text field. */
            cell = todoContentCell(tableView, indexPath: indexPath)
        case 1:
            /* display */
            cell = dueDateCell(tableView, indexPath: indexPath)
        case 2:
            // hasDatePicker will display datePickerCell or itemSelectionCell
            if hasDatePicker {
                cell = datePickerCell(tableView, indexPath: indexPath)
            } else {
                cell = itemSelectCell(tableView, indexPath: indexPath)
            }
        case 3:
            cell = dueDateCell(tableView, indexPath: indexPath)
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isDueDateIndexPath(indexPath) {
            print("didSelectRowAtIndexPath date picker: \(indexPath.row)")
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            tableView.beginUpdates()
            hasDatePicker = !hasDatePicker
            if hasDatePicker {
                tableView.insertRowsAtIndexPaths([datePickerIndexPath()], withRowAnimation: UITableViewRowAnimation.Top)
            } else {
                tableView.deleteRowsAtIndexPaths([datePickerIndexPath()], withRowAnimation: UITableViewRowAnimation.Top)
            }
            tableView.endUpdates()
        } else if isTodoListSelectIndexPath(indexPath) {
            print("didSelectRowAtIndexPath group picker: \(indexPath.row)")
            // itemSelectionController
            let todolistSelectionController = TodolistSelectionController()
            todolistSelectionController.todolistsForSelection = todoRepository.getAllTodolists()
            todolistSelectionController.selectedItem = self.todo.todolist
            todolistSelectionController.title = "todolist groups"
            // initialize delegate to call delegate method.
            todolistSelectionController.delegate = self
            self.navigationController?.pushViewController(todolistSelectionController, animated: true)
        }
    }
    
    private func todoContentCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.TodoContentEditingCell, forIndexPath: indexPath)
        (cell as! TodoContentEditingCell).content.text = self.todo.content
        return cell
    }
    
    private func dueDateCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.TodoPropertyCell, forIndexPath: indexPath)
        (cell as! TodoPropertyCell).config(Constants.TodoDateImage, label: Constants.TodoDateLabel, text: DateUtils.representationTextOfDate(todo.dueDate))
        return cell
    }
    
    private func datePickerCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.DatePickerCell, forIndexPath: indexPath)
        if let date = todo.dueDate {
            (cell as! DatePickerCell).pickerView.setDate(date, animated: true)
        } else {
            (cell as! DatePickerCell).pickerView.setDate(DateUtils.today(), animated: true)
            todo.dueDate = DateUtils.today()
            // update tableview cell dateformat.
            tableView.cellForRowAtIndexPath(dueDateIndexPath())?.detailTextLabel?.text = DateUtils.representationTextOfDate(todo.dueDate)
        }
        
        // Implemented DatePickerCellDelegate
        (cell as! DatePickerCell).delegate = self
        return cell
    }
    
    private func itemSelectCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TodoPropertyCell, forIndexPath: indexPath)
        (cell as! TodoPropertyCell).config(Constants.TodoGroupImage, label: Constants.TodoGroupLabel, text: todo.todolist!.content)
        return cell
    }
}

// MARK: - DatePickerCellDelegate
extension TodoEditingViewController: DatePickerCellDelegate {
    func dateChanged(date: NSDate) {
        self.todo.dueDate = date
        tableView.reloadRowsAtIndexPaths([dueDateIndexPath()], withRowAnimation: UITableViewRowAnimation.Fade)
        // update core data.
    }
}

// MAKR: - Helper Functions

extension TodoEditingViewController {
    
    private func isTodoListSelectIndexPath(indexPath: NSIndexPath) -> Bool {
        return (indexPath.row == 2 && !hasDatePicker) || (indexPath.row == 3 && hasDatePicker)
    }
    
    private func isDueDateIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 1
    }
    
    private func dueDateIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 1, inSection: 0)
    }
    
    private func datePickerIndexPath() -> NSIndexPath {
        return NSIndexPath(forRow: 2, inSection: 0)
    }
    
    private func isDatePickerIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 2 && hasDatePicker
    }
}

//MARK: - ItemSelectionControllerDelegate

extension TodoEditingViewController: ItemSelectionControllerDelegate {
    
    func todolistSelected(item: AnyObject) {
        let todolist = item as! Todolist
        self.todoRepository.updateForTodolist(todo, selectedTodolist: todolist)
        tableView.reloadRowsAtIndexPaths([todolistIndexPath()], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func todolistContent(item: AnyObject) -> String? {
        let todolist = item as! Todolist
        return todolist.content
    }
    
    private func todolistIndexPath() -> NSIndexPath {
        if hasDatePicker {
            return NSIndexPath(forRow: 3, inSection: 0)
        }
        return NSIndexPath(forRow: 2, inSection: 0)
    }
}