//
//  CategoryViewController.swift
//  Todolist
//
//  Created by Stephen Selvaraj on 7/15/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift



class CategoryViewController: SwipeTableViewController {
    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
     
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ?? - Nil coalsecing operator
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //let catCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        
        let catCell = super.tableView(tableView, cellForRowAt: indexPath)
    
        catCell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Found"
        
        //catCell.delegate = self
        
        return catCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let itemsVC = segue.destination as! TodolistViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            
            itemsVC.selectedCategory = categories?[indexpath.row]
    
        }
    }
    
    @IBAction func AddCategoryButton(_ sender: UIBarButtonItem) {
        
        var textCatField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            print(textCatField.text!)
            
            let newCategory = Category()
            // Both title and done property within entity is not optional
            newCategory.name = textCatField.text!
            
            //self.categoryArray.append(newCategory)
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textCatField = alertTextField
        }
        
        alert.addAction(action )
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category : Category) {
        do {
            // context.save is used for all CRUD operation except read
            try realm.write {
                realm.add(category)
                }
        } catch {
            print("Error encoding data")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
                
            } catch {
                print("Error deleting category codes")
            }
        }
    }
    
    func loadCategory ()   {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
}



