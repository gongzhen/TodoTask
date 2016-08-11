
//
//  TodosViewController.swift
//  Todo List
//
//  Created by gongzhen on 7/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit
import CoreData

class TodosViewController: UIViewController {

    var todoRepository: TodoRepository!
    var fetchedRequestsController: NSFetchedResultsController!
    var todosNotCompleted: Int!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        todoRepository = TodoRepository()
        todoRepository.initData()

        initFetchedResultController()
        // initBatchUpdate()
        DataSourceManager.sharedInstance().todos = initTodos()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "TitlebarBG"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.registerClass(TodoSectionHeaderCell.self, forHeaderFooterViewReuseIdentifier: "sectionHeaderCellIdentifier")
    }
    
    func initBatchUpdate() {
        let batchUdpate = NSBatchUpdateRequest(entityName: "Todo")
        batchUdpate.predicate = NSPredicate(format: "completed == %@", NSNumber(bool: false))
        batchUdpate.propertiesToUpdate = ["completed": NSNumber(bool:true)]
        batchUdpate.affectedStores = CoreDataStackManager.sharedInstance().managedObjectContext.persistentStoreCoordinator?.persistentStores
        batchUdpate.resultType = .UpdatedObjectsCountResultType
        
        do {
            let batchResult = try CoreDataStackManager.sharedInstance().managedObjectContext.executeRequest(batchUdpate) as! NSBatchUpdateResult
            todosNotCompleted = batchResult.result as! Int
        } catch let error as NSError {
            print("Cound not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    // MARK: Unwind
    // First put unwind function in the destination view controller, then connect the exit.
    @IBAction func todoUpdated(segue: UIStoryboardSegue) {
        print("unwind todoupdated button")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case Constants.TodoDetailsSegueID:
                let controller = segue.destinationViewController as! TodoEditingViewController
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)!
                controller.todo = getTodo(indexPath)
            case Constants.AddTodoSegueID:
                let controller = segue.destinationViewController as! TodoEditingViewController
                controller.createNewCell = true
            default:
                break
            }
        }
    }
    
    func getTodo(indexPath: NSIndexPath) -> Todo {
        return self.fetchedRequestsController.objectAtIndexPath(indexPath) as! Todo
    }
    
    func initTodos() -> [AnyObject]?{
        return self.fetchedRequestsController.fetchedObjects
    }
}

extension TodosViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //@todo: rewrite this magic number.
        return self.fetchedRequestsController.sections!.count
        // return 1
    }
    
    // Each section will return the todos based on the due date.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedRequestsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoContentCell", forIndexPath: indexPath) as! TodoContentCell
        let todo = fetchedRequestsController.objectAtIndexPath(indexPath) as! Todo
        cell.config(todo)
        // http://stackoverflow.com/questions/11540292/weird-behaviour-with-fetchedresultscontroller-in-numberofrowsinsection
        cell.delegate = self
        return cell
    }
}

extension TodosViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    // Fix the "no index path for table cell being reused" header disappear issue with return UIView not UITableViewCell.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("sectionHeaderCellIdentifier") as! TodoSectionHeaderCell
        if self.fetchedRequestsController.fetchedObjects?.count > 0 {
            cell.config("New Task", numberText: "Total \((self.fetchedRequestsController.fetchedObjects?.count)!) Task")
        } else {
            cell.config("New Task", numberText: "There are no new tasks.")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let todo = self.fetchedRequestsController.objectAtIndexPath(indexPath) as! Todo
            todoRepository.deleteTodo(todo)
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}

extension TodosViewController: TodoContentCellProtocol {
    func updateTodoState(cell: TodoContentCell, completed: Bool) {
        let indexPath = self.tableView.indexPathForCell(cell)
        if let indexPath = indexPath {
            let todo = self.getTodo(indexPath)
            if completed == true {
                // remove from tableView and CoreData
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                todoRepository.completeTodo(todo)
                self.tableView.endUpdates()
            } else {
                todoRepository.recoverTodo(todo)
            }
        }        
    }
}

// MARK: NSFetchedResultsControllerDelegate.
extension TodosViewController: NSFetchedResultsControllerDelegate {
    
    private func initFetchedResultController() {
        let managedObjectContext = CoreDataStackManager.sharedInstance().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "completed = NO")
        // let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "todolist.content", ascending: false)
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "content", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        self.fetchedRequestsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil, // fetchedObjects will set the section name from sectionNameKeyPath
            cacheName: nil)
        fetchedRequestsController.delegate = self
        
        var error: NSError?
        do {
            try fetchedRequestsController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("fetch error: \(error?.localizedDescription)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            DataSourceManager.sharedInstance().todos?.append(anObject)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            // let cell = tableView.cellForRowAtIndexPath(indexPath!) as! TodoContentCell
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    // sectionNameKeyPath: if this property is nil, controller: didChangeSection will not reach since there are no 
    // sections.
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            break
        case .Update:
            tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            break
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        DataSourceManager.sharedInstance().todos = initTodos()
        tableView.endUpdates()
    }
}

