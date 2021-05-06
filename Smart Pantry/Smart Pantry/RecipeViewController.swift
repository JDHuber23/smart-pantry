//
//  RecipeViewController.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/5/21.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeTable: UITableView!
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recipeTable.delegate = self
        recipeTable.dataSource = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func newRecipe(_ sender: Any) {
        let alert = UIAlertController(title: "New Recipe", message: "Enter the name and ingredients.", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Ingredient #1"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Ingredient #2"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Ingredient #3"
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Ingredient #4"
        }
        alert.addAction(UIAlertAction(title: "New Recipe", style: .default, handler: { (action) in
            let name = alert.textFields?[0].text!
            var ingr: [String] = []
            if let i = alert.textFields?[1].text {
                ingr.append(i)
            }
            if let i = alert.textFields?[2].text {
                ingr.append(i)
            }
            if let i = alert.textFields?[3].text {
                ingr.append(i)
            }
            if let i = alert.textFields?[4].text {
                ingr.append(i)
            }
            let ingredients: NSArray = NSArray(object: ingr)
            
            self.insertRecipe(name: name!, ingredients: ingredients)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func insertRecipe(name: String, ingredients: NSArray) {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: self.managedObjectContext)
        recipe.setValue(name, forKey: "name")
        recipe.setValue(ingredients, forKey: "ingredients")
        appDelegate.saveContext()
        self.recipeTable.reloadData()
    }
    
    func deleteRecipe(_ food: NSManagedObject) {
        managedObjectContext.delete(food)
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecipe(fetchRecipes()[indexPath.row])
            recipeTable.deleteRows(at: [indexPath], with: .fade)
            recipeTable.reloadData()
        }
    }
    
    func fetchRecipes() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        var recipes: [NSManagedObject] = []
        do {
            recipes = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getRecipes error: \(error)")
        }
        return recipes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchRecipes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTable.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let recipe = fetchRecipes()[indexPath.row]
        cell.textLabel?.text = (recipe.value(forKey: "name") as! String)
        return cell
    }
    
}
