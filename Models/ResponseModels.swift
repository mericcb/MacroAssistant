//
//  ResponseModels.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import Foundation



struct GPTResponse: Decodable {
    
    let choices: [GPTCompletion]
}


struct GPTCompletion: Decodable {
    
    let message: GPTResponseMesssage
    
    
}
    
struct GPTResponseMesssage: Decodable {
    let functionCall: GPTFunctionCall?
    
    enum CodingKeys: String, CodingKey {
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall : Decodable {
  
    let name: String
    let arguments: String
    
}

struct MacroResult: Decodable {
    let food: String
    let fats: Int
    let proteins: Int
    let carbs: Int
    
    
}
