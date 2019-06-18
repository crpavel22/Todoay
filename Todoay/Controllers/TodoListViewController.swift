//
//  ViewController.swift
//  Todoay
//
//  Created by Pavel Castillo on 6/17/19.
//  Copyright © 2019 Pavel Castillo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggs","Destroy Demogorgon"];
    var itemArray = [Item]();
    var defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray.append(Item(title: "Find Mike"));
        itemArray.append(Item(title: "Buy Eggs"));
        itemArray.append(Item(title: "Destroy Demogorgon"));
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items;
        }
        // Do any additional setup after loading the view.
        
//        if let array = defaults.array(forKey: "TodoListArray")  {
//            itemArray = array as! [String];
//        }
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.title;
        
        cell.accessoryType = item.done ? .checkmark : .none;
        
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row]);
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.reloadData();
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    // MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                self.itemArray.append(Item(title: text));
                
            }
            
            
            print("Success!! \(self.itemArray.count)");
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray");
            
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item";
            textField = alertTextField;
            
            
            
            
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
}

