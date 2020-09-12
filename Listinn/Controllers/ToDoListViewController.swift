//
//  ToDoListViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 6.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // Save the items to the specific path file.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the items.
        loadItems()
    }
    
    // MARK: - Data source methods of the table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Light", size: 17)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Delegate methods of the table view.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check of the items whether checked.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Save the items.
        saveItems()
        
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
            let newItem = Item()
            newItem.title = textField.text!
            
            // Add the new item to the to do list array.
            self.itemArray.append(newItem)
            
            // Refresh the table view.
            self.tableView.reloadData()
            
            // Save the items.
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Write a to-do..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    
    // Save the items.
    func saveItems() {
        // Save the item to the array.
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("An error occurred while encoding the data: \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("An error occurred while fetching the data: \(error)")
            }
        }
    }
}
