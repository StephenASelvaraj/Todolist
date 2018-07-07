//
//  TodolistViewController.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 6/30/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UITableViewController {

    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //TODO: Override tableview functions to return number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //Adding new rows to the table cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todolistcell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
  
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (itemArray[indexPath.row])
      
        // Next 2 lines of commented code is for D of CRUD operation code for Coredata.
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
     
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            print(textField.text!)
            
            let newItem = Item(context: self.context)
            // Both title and done property within entity is not optional
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
     
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action )
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
      do {
            // context.save is used for all CRUD operation except read
           try context.save()
        } catch {
            print("Error encoding data")
        }
        tableView.reloadData()
    }
    
    
    func loadItems () {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            itemArray = try context.fetch(request)

            } catch {
                 print("Error fetching data from sqllite ")
            }
    }
 
    
  
    
}

