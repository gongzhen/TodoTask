//
//  CoreDataStackManager.swift
//  Todo List
//
//  Created by gongzhen on 7/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation
import CoreData

private let SQLITE_FILE_NAME = "Todolist.sqlite"

class CoreDataStackManager {
    
    class func sharedInstance()-> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    // MARK: - The Core Data stack. The code has been moved, unaltered, from the AppDelegate.
    
    lazy var applicationDocumentsDirectory : NSURL = {
        // print("Instantiating the applicationDocumentsDirectory property")
        
        // DocumentDirectory and DocumentationDirectory are different.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        // print("Instantiating the managedObjectModel property")
        
        let modelURL = NSBundle.mainBundle().URLForResource("Todo", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    /**
     * The Persistent Store Coordinator is an object that the Context uses to interact with the underlying file system. Usually
     * the persistent store coordinator object uses an SQLite database file to save the managed objects. But it is possible to
     * configure it to use XML or other formats.
     *
     * Typically you will construct your persistent store manager exactly like this. It needs two pieces of information in order
     * to be set up:
     *
     * - The path to the sqlite file that will be used. Usually in the documents directory
     * - A configured Managed Object Model. See the next property for details.
     */
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        // print("Instantiating the persistentStoreCoordinator property")
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILE_NAME)
        
        // print("sqlite path: \(url.path)")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        var error: NSError? = nil
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
