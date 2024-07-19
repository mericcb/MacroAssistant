//
//  MacroViewModel.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 20.07.2024.
//

import SwiftUI
import SwiftData

class MacroViewModel: ObservableObject {
    @Published var carbs = 0
    @Published var fats = 0
    @Published var proteins = 0
    @Published var dailyMacros: [DailyMacro] = []
    @Published var lastAddedFood: String?
    @Published var lastAddedCarbs: Int?
    @Published var lastAddedFats: Int?
    @Published var lastAddedProteins: Int?
    
    func fetchDailyMacros(macros: [Macro]) {
        let dates: Set<Date> = Set(macros.map { Calendar.current.startOfDay(for: $0.date) })
        
        var newDailyMacros = [DailyMacro]()
        for date in dates {
            let filterMacros = macros.filter { Calendar.current.startOfDay(for: $0.date) == date }
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            let proteins: Int = filterMacros.reduce(0, { $0 + $1.proteins })
            
            let macro = DailyMacro(date: date, carbs: carbs, fats: fats, proteins: proteins)
            newDailyMacros.append(macro)
        }
        
        self.dailyMacros = newDailyMacros.sorted(by: { $0.date > $1.date })
    }
    
    func fetchTodaysMacro(from dailyMacros: [DailyMacro]) {
        if let todayMacro = dailyMacros.first(where: { Calendar.current.isDate($0.date, inSameDayAs: Date()) }) {
            carbs = todayMacro.carbs
            fats = todayMacro.fats
            proteins = todayMacro.proteins
        } else {
            carbs = 0
            fats = 0
            proteins = 0
        }
    }
}
