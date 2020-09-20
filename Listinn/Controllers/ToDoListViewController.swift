//
//  ToDoListViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 6.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadTheItems()
        }
    }
    
    // Save the items to the specific path file.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data source methods of the table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Light", size: 17)
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added!"
        }
        
        return cell
    }
    
    // MARK: - Delegate methods of the table view.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("An error occurred while saving the status: \(error)")
            }
        }
        
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
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        
                        // Add the new item to the to do list array.
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("An error occurred while add a new item: \(error)")
                }
            }
            
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
    
    // Load the item(s).
    func loadTheItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

// MARK: - The search bar extension of the ToDoListViewController.

//extension ToDoListViewController: UISearchBarDelegate {
//
//    // Search for content in the array based on the text typed in the search bar.
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Set a filter for the text typed in the search bar.
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        // Apply the filter.
//        loadTheItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            // Get the whole items, as not filtered.
//            loadTheItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        } else {
//
//        }
//    }
//}
