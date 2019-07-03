//
//  ViewController.swift
//  Todoay
//
//  Created by Pavel Castillo on 6/17/19.
//  Copyright © 2019 Pavel Castillo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggs","Destroy Demogorgon"];
    var todoItems:  Results<Item>?;
    let realm = try! Realm();
    //var defaults = UserDefaults.standard;
    var selectedCategory : Category? {
        didSet{
            
            loadItems();
        }
    };
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath);
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title;
            
            cell.accessoryType = item.done ? .checkmark : .none;
        } else {
            cell.textLabel?.text = "No Items Added!";
        }
        
        
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1;
    }
    

    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item);
                    item.done = !item.done;
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text {
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item();
                            newItem.title = text;
                            newItem.dateCreated = Date();
                            currentCategory.items.append(newItem);
                            self.realm.add(newItem);
                        }
                    } catch {
                        print("Error to insert items \(error)");
                    }
                }
                
            }
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item";
            textField = alertTextField;
            
            
            
            
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    //MARK: - Model manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true);

        tableView.reloadData();
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false);
        
        tableView.reloadData();
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems();

            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
}



