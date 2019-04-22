//
//  SwipeTableViewController.swift
//  todoey
//
//  Created by macbook on 4/22/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    

    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    //MARK: Table view Data source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
      
        
        cell.delegate = self
        return cell
    }
    
    
    
    
    //MARK: Table view Delegate Methods
    //Adopt the SwipeTableViewCellDelegate protocol:
    //Mandatory method
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateIndex(index: indexPath)
            
        }
        
      
        deleteAction.image = UIImage(named: "Delete")
        
        return [deleteAction]
    }

    
    // Optionally, you can implement the editActionsOptionsForRowAt method to customize the behavior of the swipe actions
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    
    
    
    //MARK General function to update cell in subclasses
    func updateIndex(index:IndexPath)
    {
        //implementaion in subclass
    }
    
    

}
