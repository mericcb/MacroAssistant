//
//  Date+Ext.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import Foundation


extension Date {
    var monthAndDay : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM\nd"
        return formatter.string(from: self)
    }
    
    var time : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:m a"
        return formatter.string(from: self)
    }
    
    var year : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
}
