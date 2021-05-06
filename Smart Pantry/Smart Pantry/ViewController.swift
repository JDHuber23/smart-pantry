//
//  ViewController.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/1/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // food items
    var filteredFoodItems: [NSManagedObject] = []
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var kitchenFilters: UISegmentedControl!
    @IBOutlet weak var foodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodTable.delegate = self
        foodTable.dataSource = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        filteredFoodItems = fetchFoodItems()
        initUser()
    }
    
    func initUser() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        var users: [NSManagedObject] = []
        do {
            users = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getUsers error: \(error)")
        }
        if users.isEmpty {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext)
            user.setValue(0, forKey: "carbohydrates")
            user.setValue(0, forKey: "fat")
            user.setValue(0, forKey: "sugar")
            user.setValue(0, forKey: "sodium")
            user.setValue(0, forKey: "protein")
            appDelegate.saveContext()
            self.foodTable.reloadData()
        }
    }

    @IBAction func cookedRecipe(_ sender: Any) {
        let alert = UIAlertController(title: "I cooked!", message: "What recipe did you cook?", preferredStyle: .alert)
        
        // we want to reduce the amount for each food item that was eaten
        // for simplicity's sake every ingredient uses 1 amount of it
        
        alert.addTextField { (textField) in
            textField.placeholder = "Recipe Name"
        }
        
        alert.addAction(UIAlertAction(title: "I cooked!", style: .default, handler: { (action) in
            let recipeName = alert.textFields?[0].text!
            let fetchPredicate = NSPredicate(format: "name == %@", recipeName!)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
            fetchRequest.predicate = fetchPredicate
            var recipes: [NSManagedObject] = []
            do {
                recipes = try self.managedObjectContext.fetch(fetchRequest)
            } catch {
                print("getRecipe error: \(error)")
            }
            if recipes.isEmpty {
                return
            }
            let ingredients = recipes[0].value(forKey: "ingredients") as! NSArray
            for ingredient in ingredients {
                self.consumeFoodItem(foodName: ingredient as! String)
            }
        }))
        
    }
    
    @IBAction func ateFood(_ sender: Any) {
        let alert = UIAlertController(title: "I ate!", message: "What food item did you eat?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Food Item Name"
        }
        
        alert.addAction(UIAlertAction(title: "I ate!", style: .default, handler: { (action) in
            let foodName = alert.textFields?[0].text!
            self.consumeFoodItem(foodName: foodName!)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func consumeFoodItem(foodName: String) {
        let fetchPredicate = NSPredicate(format: "name == %@", foodName)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FoodItem")
        fetchRequest.predicate = fetchPredicate
        var food: [NSManagedObject] = []
        do {
            food = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getFood error: \(error)")
        }
        if food.isEmpty {
            return
        }
        let amount = food[0].value(forKey: "amount")
        food[0].setValue(amount as! Int - 1, forKey: "amount")
        self.updateUser(food: food[0] as! FoodItem)
        self.appDelegate.saveContext()
        self.foodTable.reloadData()
    }
    
    func updateUser(food: FoodItem) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        var users: [NSManagedObject] = []
        do {
            users = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getUsers error: \(error)")
        }
        let userSodium = users[0].value(forKey: "sodium")
        let userFat = users[0].value(forKey: "fat")
        let userCarbohydrates = users[0].value(forKey: "carbohydrates")
        let userSugar = users[0].value(forKey: "sugar")
        let userProtein = users[0].value(forKey: "protein")
        
        users[0].setValue(userSodium as! Int32 + food.sodium, forKey: "sodium")
        users[0].setValue(userFat as! Int32 + food.fat, forKey: "fat")
        users[0].setValue(userCarbohydrates as! Int32 + food.carbohydrates, forKey: "carbohydrates")
        users[0].setValue(userSugar as! Int32 + food.sugar, forKey: "sugar")
        users[0].setValue(userProtein as! Int32 + food.protein, forKey: "protein")
        
    }
    
    
    @IBAction func addFood(_ sender: Any) {
        let alert = UIAlertController(title: "Add Food Item", message: "Enter the name, amount, and nutritional values.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Amount"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Pantry, Fridge, Freezer"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Carbohydrates (grams)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Sodium (grams)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Fat (grams)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Protein (grams)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Sugar (grams)"
        }
        alert.addAction(UIAlertAction(title: "Add Food Item", style: .default, handler: { (action) in
            let name = alert.textFields?[0].text!
            let amount = Int(alert.textFields?[1].text ?? "0")!
            let location = alert.textFields?[2].text!
            let carbs = Int(alert.textFields?[3].text ?? "0")!
            let sodium = Int(alert.textFields?[4].text ?? "0")!
            let fat = Int(alert.textFields?[5].text ?? "0")!
            let protein = Int(alert.textFields?[6].text ?? "0")!
            let sugar = Int(alert.textFields?[7].text ?? "0")!
            
            self.insertFood(name: name!, amount: amount, location: location!, carbohydrates: carbs, protein: protein, sugar: sugar, fat: fat, sodium: sodium)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterFood(_ sender: Any) {
        var filteredFood = fetchFoodItems()
        switch kitchenFilters.selectedSegmentIndex {
            case 0:
                filteredFood = fetchFoodItems()
            case 1:
                filteredFood = fetchFoodItems().filter({(f) -> Bool in f.value(forKey: "location") as! String == "Pantry"})
            case 2:
                filteredFood = fetchFoodItems().filter({(f) -> Bool in f.value(forKey: "location") as! String == "Fridge"})
            case 3:
                filteredFood = fetchFoodItems().filter({(f) -> Bool in f.value(forKey: "location") as! String == "Freezer"})
            default:
                filteredFood = fetchFoodItems()
        }
        self.filteredFoodItems = filteredFood
        self.foodTable.reloadData()
    }
    
    func fetchFoodItems() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FoodItem")
        var food: [NSManagedObject] = []
        do {
            food = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getFood error: \(error)")
        }
        return food
    }
    
    func insertFood(name: String, amount: Int, location: String, carbohydrates: Int, protein: Int, sugar: Int, fat: Int, sodium: Int) {
        let food = NSEntityDescription.insertNewObject(forEntityName: "FoodItem", into: self.managedObjectContext)
        food.setValue(name, forKey: "name")
        food.setValue(amount, forKey: "amount")
        food.setValue(location, forKey: "location")
        food.setValue(carbohydrates, forKey: "carbohydrates")
        food.setValue(protein, forKey: "protein")
        food.setValue(sugar, forKey: "sugar")
        food.setValue(fat, forKey: "fat")
        food.setValue(sodium, forKey: "sodium")
        appDelegate.saveContext()
        self.foodTable.reloadData()
    }
    
    func deleteFood(_ food: NSManagedObject) {
        managedObjectContext.delete(food)
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTable.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        let foodItem = filteredFoodItems[indexPath.row]
        // configure cell
        cell.textLabel?.text = (foodItem.value(forKey: "name") as! String)
        cell.detailTextLabel?.text = String(foodItem.value(forKey: "amount") as! Int)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFood(fetchFoodItems()[indexPath.row])
            foodTable.deleteRows(at: [indexPath], with: .fade)
            foodTable.reloadData()
        }
    }
    
    
}

