//
//  ViewController.swift
//  todoey
//
//  Created by macbook on 4/8/19.
//  Copyright © 2019 macbook. All rights reserved.
//

import UIKit

import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todolistItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?
    {
        didSet {
            loadItems()
        }
    }
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
       title = selectedCategory?.name
        guard let colour =  selectedCategory?.color else
        {
          fatalError("no color")
        }
        updateNavigation(with: colour)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavigation(with:"5B9FCB")
    }
    
    //MARK : Update Navigation bar
    func updateNavigation (with hexaValue:String)
    {
        guard let navBar = navigationController?.navigationBar else {fatalError("No Navigation Controller is Founded")}
        guard let navColour = UIColor(hexString: hexaValue) else {
            fatalError("Can't Assign Color To Navigation Bar")
        }
        navBar.barTintColor = navColour
        navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: navColour, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(contrastingBlackOrWhiteColorOn: navColour, isFlat: true)]
        
        searchBar.barTintColor = navColour
        
    }
    
    
    
    // MARK: ... TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        return todolistItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todolistItems?[indexPath.row]
        {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
           
            let X = CGFloat(indexPath.row)/CGFloat((todolistItems?.count)!)
    
            cell.backgroundColor = UIColor(hexString: selectedCategory?.color)?.darken(byPercentage: X)
            
            cell.textLabel?.textColor =  UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor, isFlat: true)
            
        }
        else
        {
            
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    
    
    //MARK: ...TableView Delegate Mehtods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
      if let item = todolistItems?[indexPath.row]
      {
        
       do{
         try realm.write
          {
           item.checked = !item.checked
            //if need to delete
            //realm.delete(item)
            
          }
         }
         catch
          {
            print("Can't Update Data")
          }
       }
     
    
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
     
    }
    
    // MARK: ... Add item section
    
    @IBAction func addTapped(_ sender: UIBarButtonItem)
    {
        var newTextField = UITextField()
     let alert = UIAlertController(title: "Adding", message: "Add New Item", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Item", style: .default)
        {
            (UIAlertAction) in
       if(newTextField.text != "")
     {
        if let currentCategory = self.selectedCategory
               
        {
          do
             {
                try self.realm.write
                {
                    let newItem = Item()
                    newItem.title = newTextField.text!
                    newItem.checked = false
                   
                    self.realm.add(newItem)
                    currentCategory.items.append(newItem)
                   
                    
                }
              }
              catch
                {
                print("Cant Save items ")
                }
        }
         self.tableView.reloadData()
     }
        
  }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField
        {
            (textContent) in
            newTextField = textContent
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    
    }
    

    //MARK: implement Model Data manipulation using Realm
    //----------------------------
    
    
    //TODO: ٬Load Date
    func loadItems()
    {
        do
        {
            todolistItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        }
    }
    
    
    override func updateIndex(index: IndexPath) {
        do
        {
            try realm.write {
                realm.delete(todolistItems![index.row])
            }
        }
        catch
        {
           print("Cant delete item")
        }
    }
   
}

extension ToDoListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.count==0
        {

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }

            loadItems()
            tableView.reloadData()
        }
        else
        {
 
            
            todolistItems = todolistItems?.filter("title CONTAINS [cd] %@",searchBar.text!)
            tableView.reloadData()
            
        }
    }

}
