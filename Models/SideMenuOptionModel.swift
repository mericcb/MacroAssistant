//
//  SideMenuOptionModel.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 10.07.2024.
//

import Foundation


enum SideMenuOptionModel: Int, CaseIterable {
    case macros
    case performance
    case settings
    
    var title: String {
        switch self {
            
        case .macros:
            return "Macros"
        case .performance:
            return "Performance"
        case .settings:
            return "Settings"
        }
    }
    
    var systmeImageName: String {
        switch self {
            
        case .macros:
            return "fork.knife"
        case .performance:
            return "chart.bar"
        case .settings:
            return "gearshape.fill"
        }
    }
    
}

extension SideMenuOptionModel : Identifiable {
    var id: Int { return self.rawValue }
}

   
