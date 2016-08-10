//
//  Todolist+CoreDataProperties.swift
//  Todo List
//
//  Created by gongzhen on 7/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Todolist {

    @NSManaged var content: String?
    @NSManaged var deletedFlag: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var updatedTime: NSDate?
    @NSManaged var todos: NSSet?

}
