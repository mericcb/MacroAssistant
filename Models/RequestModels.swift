//
//  RequestModels.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import Foundation

struct GPTChatPayload: Encodable {
    
    let model: String
    let messages: [GPTMessage]
    let functions: [GPTFunction]
}


struct GPTMessage: Encodable {
    
    let role: String
    let content: String

}

struct GPTFunction: Encodable {
    let name: String
    let description: String
    let parameters: GPTFunctionParam
}


struct GPTFunctionParam: Encodable {
    
    let type: String
    let properties: [String: GPTFunctionProperty]
    let required: [String]?
}

struct GPTFunctionProperty: Encodable {
    
    let type: String
    let description: String
}
    
