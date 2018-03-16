//
//  ViewController.swift
//  todoey
//
//  Created by 李俊澔 on 2018/3/12.
//  Copyright © 2018年 icerushqq. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items"
        }
       
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//
        //saveItems()
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
//    MARK: Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new  item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add new item", style: .default) { (action) in
//            //what will happen when click add on UIAlert
//
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//
//            self.itemArray.append(newItem)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    
                }
                self.tableView.reloadData()
            }
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
//    MARK: saveItems Methods
    func saveItems(newItem : Item) {

        do {
            try realm.write {
                realm.add(newItem)
            }
        } catch {
          print("Error saving context")
        }
        self.tableView.reloadData()
    }

    //MARK: loadItems Methods
    func loadItems() {

         todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addtionalPredicate = predicates {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("load item error \(error)")
//        }

        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

          todoItems = todoItems?.filter("title contains[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
 }
    

