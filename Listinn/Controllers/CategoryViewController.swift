//
//  CategoryViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 19.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        // Set the rows of the table view as 80.
        tableView.rowHeight = 80
        
        // Remove the seperators between the table view items.
        tableView.separatorStyle = .none
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Medium", size: 20)
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "C67739")
        
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("An error occurred while saving the category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete A Category
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("An error occurred while deleting the category: \(error)")
            }
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonHandler(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        })
        alertController.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alertController, animated: true, completion: nil)
    }
}
