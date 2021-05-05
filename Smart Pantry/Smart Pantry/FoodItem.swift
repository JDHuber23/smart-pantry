//
//  FoodItem.swift
//  Smart Pantry
//
//  Created by Jacob Huber on 5/3/21.
//

import Foundation

class FoodItem {
    
    var name: String
    var amount: Int
    var location: String
    var carbohydrates: Int
    var protein: Int
    var sugar: Int
    var fat: Int
    var sodium: Int
    
    init(name: String, amount: Int, location: String, carbohydrates: Int, protein: Int, sugar: Int, fat: Int, sodium: Int) {
        self.name = name
        self.amount = amount
        self.location = location
        self.carbohydrates = carbohydrates
        self.protein = protein
        self.sugar = sugar
        self.fat = fat
        self.sodium = sodium
    }
    
}
