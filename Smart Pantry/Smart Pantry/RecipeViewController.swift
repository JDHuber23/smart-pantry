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
