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
    var foodItems: [NSManagedObject] = []
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
        var filteredFood = foodItems
        switch kitchenFilters.selectedSegmentIndex {
            case 0:
                filteredFood = foodItems
            case 1:
                filteredFood = foodItems.filter({(f) -> Bool in f.value(forKey: "location") as! String == "Pantry"})
            case 2:
                filteredFood = foodItems.filter({(f) -> Bool in f.value(forKey: "location") as! String == "Fridge"})
            case 3:
                filteredFood = foodItems.filter({(f) -> Bool in f.value(forKey: "location") as! String == "Freezer"})
            default:
                filteredFood = foodItems
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
        self.foodItems.append(food)
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
        cell.detailTextLabel?.text = String(foodItem.value(forKey: "amount") as! String)
        
        return cell
    }
}

