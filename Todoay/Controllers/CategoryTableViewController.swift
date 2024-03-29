//
//  CategoryTableViewController.swift
//  Todoay
//
//  Created by Pavel Castillo on 7/1/19.
//  Copyright © 2019 Pavel Castillo. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController{
    
    let realm = try! Realm();
    
    var categoryArray: Results<Category>?;
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories();
        
        
        
    }
    
    //    MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Not categories added yet!";
        
        let categoryColour = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6");
        
        cell.backgroundColor = categoryColour;
        
        cell.textLabel?.textColor = ContrastColorOf(categoryColour!, returnFlat: true);
        
        
        return cell;
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return categoryArray?.count ?? 1;
    }
    
    //    MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category)  {
        do {
            try realm.write {
                realm.add(category);
            };
        } catch {
            print("Error saving context \(error)");
        }
        
        tableView.reloadData();
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self);
        
        
        //
        tableView.reloadData();
    }
    
    //    MARK: - Add New Categories
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New ToDo Category", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = textField.text {
                
                let newCategory = Category();
                newCategory.name = text;
                newCategory.color = UIColor.randomFlat.hexValue();
                
                //                self.categoryArray.append(newCategory);
                self.saveCategories(category: newCategory);
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category";
            textField = alertTextField;
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
        
    }
    
    //    MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self);
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if var indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row];
        }
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category);
                }
            } catch {
                print("Error to delete category \(error)");
            }
        }
        
        
    }
    
    
}


