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
    //var defaults = UserDefaults.standard;
    let dataFiledPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems();
        
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
        
        saveItems();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                self.itemArray.append(Item(title: text));
                
            }
            
            
            print("Success!! \(self.itemArray.count)");
            
            self.saveItems();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item";
            textField = alertTextField;
            
            
            
            
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    //MARK - Model manipulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder();
        
        do{
            let data = try encoder.encode(itemArray);
            try data.write(to: dataFiledPath!);
        } catch {
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData();
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFiledPath!) {
            let decoder = PropertyListDecoder();
            
            do{
                itemArray = try decoder.decode([Item].self, from: data);
            } catch {
                print("Error decoding item array \(error)")
            }
        }
        
    }
    
}



