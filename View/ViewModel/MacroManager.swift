//
//  MacroManager.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 13.07.2024.
//

import SwiftUI
import SwiftData

class MacroManager: ObservableObject {
    @Published var selectedMacro: Macro?
    @Published var macros: [Macro] = []
    
    
    func addMacro(_ macro: Macro, context: ModelContext) {
            context.insert(macro)
            macros.append(macro)
            selectedMacro = macro
            saveContext(context: context)
        }
    
    func macrosForDate(_ date: Date) -> DailyMacro {
           let filteredMacros = macros.filter {
               Calendar.current.isDate($0.date, inSameDayAs: date)
           }
           
           let totalFats = filteredMacros.reduce(0) { $0 + $1.fats }
           let totalCarbs = filteredMacros.reduce(0) { $0 + $1.carbs }
           let totalProteins = filteredMacros.reduce(0) { $0 + $1.proteins }

           return DailyMacro(date: date, carbs: totalCarbs, fats: totalFats, proteins: totalProteins)
       }
    
    func fetchDailyMacros() -> [DailyMacro] {
           let dates: Set<Date> = Set(macros.map { Calendar.current.startOfDay(for: $0.date) })
           
           var dailyMacros = [DailyMacro]()
           for date in dates {
               let filterMacros = macros.filter { Calendar.current.startOfDay(for: $0.date) == date }
               let carbs: Int = filterMacros.reduce(0) { $0 + $1.carbs }
               let fats: Int = filterMacros.reduce(0) { $0 + $1.fats }
               let proteins: Int = filterMacros.reduce(0) { $0 + $1.proteins }
               
               let macro = DailyMacro(date: date, carbs: carbs, fats: fats, proteins: proteins)
               dailyMacros.append(macro)
           }
           
           return dailyMacros.sorted(by: { $0.date > $1.date })
       }
       
    func fetchTodaysMacro(dailyMacros: [DailyMacro]) -> DailyMacro? {
            if let firstDateMacro = dailyMacros.first, Calendar.current.startOfDay(for: firstDateMacro.date) == Calendar.current.startOfDay(for: .now) {
                return firstDateMacro
            }
            return nil
        }
    
    func loadMacros(context: ModelContext) {
        let fetchRequest = FetchDescriptor<Macro>()
        do {
            macros = try context.fetch(fetchRequest)
        }catch {
            print("Error fetching macros: \(error.localizedDescription)")
        }
    }
    
    private func saveContext(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    
}
