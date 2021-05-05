//
//  ViewController.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/1/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // food items
    var foodItems: [FoodItem] = []
    var filteredFoodItems: [FoodItem] = []
    
    @IBOutlet weak var kitchenFilters: UISegmentedControl!
    var selectedLocation: String
    @IBOutlet weak var foodTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodTable.delegate = self
        foodTable.dataSource = self
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
            
            let foodItem = FoodItem(name: name!, amount: amount, location: location!, carbohydrates: carbs, protein: protein, sugar: sugar, fat: fat, sodium: sodium)
            self.foodItems.append(foodItem)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func filterFood(_ sender: Any) {
        switch kitchenFilters.selectedSegmentIndex {
            case 0:
                selectedLocation = "All"
            case 1:
                selectedLocation = "Pantry"
            case 2:
                selectedLocation = "Fridge"
            case 3:
                selectedLocation = "Freezer"
            default:
                selectedLocation = "All"
        }
        
        self.foodTable.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFoodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTable.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        
        let foodItem = filteredFoodItems[indexPath.row]
        // configure cell
        cell.textLabel?.text = foodItem.name
        cell.detailTextLabel?.text = String(foodItem.amount)
        
        return cell
    }
}

