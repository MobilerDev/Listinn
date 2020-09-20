//
//  CategoryViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 19.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Medium", size: 17)
        
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
    
    
    // MARK: - Add New Categories

    @IBAction func addButtonHandler(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        })
        alertController.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alertController, animated: true, completion: nil)
    }
}
