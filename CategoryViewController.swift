//
//  CategoryViewController.swift
//  todoey
//
//  Created by macbook on 4/15/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController
{

    var categories : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
        loadCategory()
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category added Yet"
        
       
       cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color)
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
        
        
        return cell

        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         performSegue(withIdentifier: "gotoItems", sender: self)
      // context.delete(categoryArray[indexPath.row])
        //categoryArray.remove(at: indexPath.row)
        //saveCategory()
        //tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (categories?.count)!>1
        {
        let destinationVC = segue.destination as! ToDoListViewController
        
        let selectedIndex = tableView.indexPathForSelectedRow?.row
        
            destinationVC.selectedCategory = (categories?[selectedIndex!])!
        }
    }
    
    @IBAction func addbuttonTapped(_ sender: UIBarButtonItem)
    {
        let newItem = Category()
        
        var mytextfield = UITextField()
        
        
        let alert = UIAlertController(title: "", message: "Add Category", preferredStyle: .alert)
        alert.addTextField
            {
                (enteredText) in
                
                mytextfield = enteredText
                mytextfield.placeholder = "Add New Category"
                
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            (myalertaction) in
            if mytextfield.text != nil
            {
             newItem.name = mytextfield.text!
                newItem.color = (UIColor.randomFlat()?.hexValue())!
               
               
           
            self.saveCategory(category: newItem)
            self.tableView.reloadData()
            }
            
        }))
    
       let cancelbutton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelbutton)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data mainuplation with realm
    
    func saveCategory(category:Category)
    {
    do
     {
      try realm.write
        {
            
          
          realm.add(category)
            
        }
     }
    catch
        {
            print ("cant save item")
        }
   
    }
    
    func loadCategory()
    {
        categories = realm.objects(Category.self)
    }
    
    override func updateIndex(index: IndexPath)
    {
        do
        {
            try realm.write {
                realm.delete(categories![index.row])
            }
        }
        catch
        {
            print ("cant delete item")
        }
        
    }
    
    

}
