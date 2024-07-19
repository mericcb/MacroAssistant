//
//  DailyMacro.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import Foundation


struct DailyMacro: Identifiable {
    let id = UUID()
    let date: Date
    let carbs: Int
    let fats: Int
    let proteins: Int
}
