//
//  ViewController.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    // food items
    var food: [FoodItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            textField.placeholder = "Carbohydrates"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Sodium"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Fat"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Protein"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Sugar"
        }
        
    }
}

