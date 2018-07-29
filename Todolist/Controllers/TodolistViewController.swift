//
//  TodolistViewController.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 6/30/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodolistViewController: UITableViewController {
    
    var itemsresults : Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var NavBarTitle: UINavigationItem!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NavBarTitle.title = selectedCategory?.name
    }
    
    
    //TODO: Override tableview functions to return number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsresults?.count ?? 1
    }
    
    //Adding new rows to the table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolistcell", for: indexPath)
        
        if let item = itemsresults?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = itemsresults?[indexPath.row] {
            do {
                //Updating records
                try realm.write {
                    item.done = !item.done
                    // Uncomment next line to delete data from the realm database
                    //realm.delete(Data)
                    }
            } catch {
                print("Error saving done status")
            }
            
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    
                    let newItem = Item()
                    
                    newItem.title = textField.text!
                    newItem.done = false
                    currentCategory.items.append(newItem)
                    

                }
                } catch {
                    print("Error saving new items")
                }
            }
            self.tableView.reloadData()
   
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action )
        
        present(alert, animated: true, completion: nil)
    }
    
  
    func loadItems ()   {
        
        itemsresults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
}
//MARK : - Searbar
extension TodolistViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemsresults = itemsresults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
  
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



