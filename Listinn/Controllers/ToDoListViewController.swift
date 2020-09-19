//
//  ToDoListViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 6.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadTheItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Save the items to the specific path file.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data source methods of the table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Light", size: 17)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Delegate methods of the table view.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Delete an item.
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        // Check of the items whether checked.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Save the change of an item.
        saveAnItem()
        
        // Reload the table view after the check action.
        tableView.reloadData()
        
        // Deselect the selected row of the table view.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add a new item.
    
    @IBAction func addNewItemHandler(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        textField.font = UIFont(name: "SanFranciscoDisplay-Light", size: 15)
        
        let alert = UIAlertController(title: "Add new Listinn Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            // Add the new item to the to do list array.
            self.itemArray.append(newItem)
            
            // Save an item.
            self.saveAnItem()
            
            // Refresh the table view.
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write a to-do..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    // Save an item.
    func saveAnItem() {
        // Save the item to the array.
        do {
            try context.save()
        } catch {
            print("An error occurred while saving the data: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Load the item(s).
    func loadTheItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("An error occurred while fetching the data: \(error)")
        }
    }
}

// MARK: - The search bar extension of the ToDoListViewController.

extension ToDoListViewController: UISearchBarDelegate {
    
    // Search for content in the array based on the text typed in the search bar.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Set a filter for the text typed in the search bar.
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Apply the filter.
        loadTheItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // Get the whole items, as not filtered.
            loadTheItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            
        }
    }
}
