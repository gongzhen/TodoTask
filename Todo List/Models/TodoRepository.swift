//
//  TodoRepository.swift
//  Todo List
//
//  Created by gongzhen on 7/27/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation
import CoreData

struct Section {
    var name: String!
    var collapsed: Bool!
    
    init(name:String, collapsed: Bool = false) {        
        self.name = name
        self.collapsed = collapsed
    }
}

class TodoRepository{
    
    // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    func initData() {
        
        if getAllTodolists().count > 0 {
            return
        }
        
        deleteAllData()
        
        let defaultList = NSEntityDescription.insertNewObjectForEntityForName("Todolist", inManagedObjectContext: self.sharedContext) as! Todolist
        defaultList.content = "Work"
        defaultList.deletedFlag = 0
        defaultList.order = 0
        defaultList.updatedTime = DateUtils.today()

        let tomorrowList = NSEntityDescription.insertNewObjectForEntityForName("Todolist", inManagedObjectContext: self.sharedContext) as! Todolist
        tomorrowList.content = "Life"
        tomorrowList.deletedFlag = 0
        tomorrowList.order = 0
        tomorrowList.updatedTime = DateUtils.today()
        
        let todo1 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: sharedContext) as! Todo
        todo1.content = "Press + button to create new task."
        todo1.completed = false
        todo1.dueDate = DateUtils.today()
        todo1.completedTime = DateUtils.today()
        todo1.deletedFlag = 0
        todo1.order = 0
        todo1.updatedTime = DateUtils.today()
        todo1.category = 1  // TODY
        todo1.todolist = defaultList
        
        
        let todo2 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: sharedContext) as! Todo
        todo2.content = "Press the round button to finish."
        todo2.completed = false
        todo2.dueDate = DateUtils.today()
        todo2.completedTime = DateUtils.today()
        todo2.deletedFlag = 0
        todo2.order = 0
        todo2.updatedTime = DateUtils.today()
        todo2.category = 1 // PASS
        todo2.todolist = tomorrowList
        
        let todo3 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: sharedContext) as! Todo
        todo3.content = "Swip the task left to delete."
        todo3.completed = false
        todo3.dueDate = DateUtils.today()
        todo3.completedTime = DateUtils.today()
        todo3.deletedFlag = 0
        todo3.order = 0
        todo3.updatedTime = DateUtils.today()
        todo3.category = 1  // TODY
        todo3.todolist = defaultList

        let todo4 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: sharedContext) as! Todo
        todo4.content = "Press the task to edit."
        todo4.completed = false
        todo4.dueDate = DateUtils.today()
        todo4.completedTime = DateUtils.today()
        todo4.deletedFlag = 0
        todo4.order = 0
        todo4.updatedTime = DateUtils.today()
        todo4.category = 1  // TODY
        todo4.todolist = defaultList
        
        let todo5 = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: sharedContext) as! Todo
        todo5.content = "See your tasks from calendar."
        todo5.completed = false
        todo5.dueDate = DateUtils.today()
        todo5.completedTime = DateUtils.today()
        todo5.deletedFlag = 0
        todo5.order = 0
        todo5.updatedTime = DateUtils.today()
        todo5.category = 1  // TODY
        todo5.todolist = defaultList
        
        // save to core data
        // Fixed bug related to the sharedInsace.
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func getAllTodos() -> [Todo] {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        do {
            return try self.sharedContext.executeFetchRequest(fetchRequest) as! [Todo]
        } catch _ {
            return [Todo]()
        }
    }
    
    func getAllTodolists() -> [Todolist] {
        let fetchRequest = NSFetchRequest(entityName: "Todolist")
        do{
            return try self.sharedContext.executeFetchRequest(fetchRequest) as! [Todolist]
        } catch _ {
            return [Todolist]()
        }
    }
    
    func completeTodo(todo: Todo) {
        todo.completed = true
        todo.completedTime = NSDate()
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func deleteAllData() {
        for todo in getAllTodos() {
            self.sharedContext.deleteObject(todo)
        }
        
        for todolist in getAllTodolists() {
            self.sharedContext.deleteObject(todolist)
        }
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func initSection() -> [Section]{
        let sections:[Section] = [
            Section(name: "Today", collapsed: false),
            Section(name: "Tomorrow", collapsed: false),
            Section(name: "Next 7 Days", collapsed: false),
            Section(name: "InBox", collapsed: false)
        ]
        return sections
    }
    
    // print todos that in EditViewController
    func printTodos() {
        let todos = getAllTodos()
        for todo in todos {
            print("todo: \((todo.content)!)")
            print("todo's todolist: \((todo.todolist?.content)!)")
        }
        
        let todolists = getAllTodolists()
        for todolist in todolists {
            print("todolist: \(todolist.content!)")
            for todo in todolist.todos! {
                print("todolist's todo: \((todo.content)!)")
            }
            print("todolist's todos: \(todolist.todos)")
        }
    }
    
    func updateForTodolist(todo: Todo, selectedTodolist: Todolist) {
        print("updateForTodolist: \(todo.content!), \(selectedTodolist.content!)")
        todo.todolist = selectedTodolist
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func getCompletedTodos() -> [Todo] {
        let fetchRequest = NSFetchRequest(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "completed = YES")
        do{
            return try self.sharedContext.executeFetchRequest(fetchRequest) as![Todo]
        } catch _ {
            return [Todo]()
        }
    }
    
    func recoverTodo(todo: Todo) {
        todo.completed = false
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func deleteTodo(todo: Todo) {
        CoreDataStackManager.sharedInstance().managedObjectContext.deleteObject(todo)
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func createNewTodo() -> Todo {
        let todo = NSEntityDescription.insertNewObjectForEntityForName("Todo", inManagedObjectContext: self.sharedContext) as! Todo
        todo.content = ""
        todo.completed = false
        todo.dueDate = DateUtils.today()
        todo.category = 1
        // Bug fixed: attach todo's todolist with the first todolists of default todolists.
        todo.todolist = getAllTodolists()[0]
        
        CoreDataStackManager.sharedInstance().saveContext()
        return todo
    }
}