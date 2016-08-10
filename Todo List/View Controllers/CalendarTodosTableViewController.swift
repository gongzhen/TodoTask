//
//  CalendarTodosTableViewController.swift
//  Todo List
//
//  Created by gongzhen on 8/9/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class CalendarTodosTableViewController: UITableViewController {
    
    var todoDict:[String: [AnyObject]]!
    var todos:[AnyObject]!
    var key: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        for (key, todos) in todoDict {
            if self.key == key {
                self.todos = todos
            }
        }
        let leftButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CalendarTodosTableViewController.cancelCreating))
        self.navigationItem.leftBarButtonItem = leftButton
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "uitableViewCellIdentifier")
    }
    
    func cancelCreating() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.todos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("uitableViewCellIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.stringFromDate((self.todos as! [Todo])[indexPath.row].dueDate!)
        cell.textLabel?.text = (self.todos as! [Todo])[indexPath.row].content
        
        let detailTextLabel = UILabel(frame: CGRect.null)
        detailTextLabel.textAlignment = .Right
        detailTextLabel.text = dateString
        detailTextLabel.font = UIFont.boldSystemFontOfSize(17.0)
        detailTextLabel.backgroundColor = UIColor.clearColor()
        cell.contentView.addSubview(detailTextLabel)
        
        let viewsDictionary = ["detailTextLabel":detailTextLabel]
        
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints_H = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[detailTextLabel(>=100)]-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: viewsDictionary
        )
        let labelConstraints_V = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[detailTextLabel]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        )
        cell.contentView.addConstraints(labelConstraints_H)
        cell.contentView.addConstraints(labelConstraints_V)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = (self.todos[indexPath.row] as! Todo)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        let editViewController = storyBoard.instantiateViewControllerWithIdentifier("TodoEditingViewController") as! TodoEditingViewController
        editViewController.todo = todo        
        let navigationController = UINavigationController(rootViewController: editViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue: \(segue.identifier)")
    }
    
}
