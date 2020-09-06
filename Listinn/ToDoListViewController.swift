//
//  ToDoListViewController.swift
//  Listinn
//
//  Created by Yuşa Sarısoy on 6.09.2020.
//  Copyright © 2020 Yuşa Sarısoy. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [
        "Fight Club (1999)",
        "The American History X (1998)"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data source methods of the table view.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: - Delegate methods of the table view.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check of the items whether checked.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // Deselect the selected row of the table view.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add a new item.
    
    @IBAction func addNewItemHandler(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Listinn Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Add the new item to the to do list array.
            self.itemArray.append(textField.text!)
            
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
}
