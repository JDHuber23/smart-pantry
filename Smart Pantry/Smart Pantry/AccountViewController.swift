//
//  AccountViewController.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/5/21.
//

import UIKit
import CoreData

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var managedObjectContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var sugarConsumed: UILabel!
    @IBOutlet weak var fatConsumed: UILabel!
    @IBOutlet weak var carbohydratesConsumed: UILabel!
    @IBOutlet weak var sodiumConsumed: UILabel!
    @IBOutlet weak var proteinConsumed: UILabel!
    
    @IBOutlet weak var shoppingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func updateLabels() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        var users: [NSManagedObject] = []
        do {
            users = try self.managedObjectContext.fetch(fetchRequest)
        } catch {
            print("getUsers error: \(error)")
        }
        if !users.isEmpty {
            let user = users[0] as! User
            sugarConsumed.text = "Sugar consumed = \(user.sugar) grams"
            fatConsumed.text = "Fat consumed = \(user.fat) grams"
            carbohydratesConsumed.text = "Carbohydrates consumed = \(user.carbohydrates) grams"
            sodiumConsumed.text = "Sodium consumed = \(user.sodium) grams"
            proteinConsumed.text = "Protein consumed = \(user.protein) grams"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
