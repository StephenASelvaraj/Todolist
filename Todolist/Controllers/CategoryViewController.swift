//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 7/15/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        catCell.textLabel?.text = category.name
        
        return catCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemsVC = segue.destination as! TodolistViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            
            itemsVC.selectedCategory = categoryArray[indexpath.row]
    
        }
    }
    
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        
        var textCatField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print(textCatField.text!)
            
            let newCategory = Category(context: self.context)
            // Both title and done property within entity is not optional
            newCategory.name = textCatField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textCatField = alertTextField
        }
        
        alert.addAction(action )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategory () {
        do {
            // context.save is used for all CRUD operation except read
            try context.save()
        } catch {
            print("Error encoding data")
        }
        tableView.reloadData()
    }
    
    func loadCategory (with request: NSFetchRequest<Category> = Category.fetchRequest())   {
        
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
            
        } catch {
            print("Error fetching data from sqllite ")
        }
        tableView.reloadData()
    }
    
}

