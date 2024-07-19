//
//  Macro.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import Foundation
import SwiftData

@Model
final class Macro: ObservableObject, Identifiable {
    @Attribute var id: UUID = UUID()
    var food: String
    var createdAt: Date
    var date: Date
    var fats: Int
    var carbs: Int
    var proteins: Int
    
    init(food: String, createdAt: Date, date: Date, fats: Int, carbs: Int, proteins: Int) {
        self.food = food
        self.createdAt = createdAt
        self.date = date
        self.fats = fats
        self.carbs = carbs
        self.proteins = proteins
    }
}
