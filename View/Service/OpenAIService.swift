//
//  OpenAIService.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 3.07.2024.
//

import Foundation


enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum OpenAIError: Error {
    case noFucntionCall
    case unableToConvertStringIntoData
}


class OpenAIService {
    
    static let shared = OpenAIService()
    
    private init () { }
    
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        //MARK: Method
        urlRequest.httpMethod = httpMethod.rawValue
        
        //MARK: Header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        
        //MARK: - Body
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert.")
        let userMessage = GPTMessage(role: "user", content: message)

        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. Hamburger")
        let fats = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carbs = GPTFunctionProperty(type: "integer", description: "The amount of carbs in grams of the given food item")
        let proteins = GPTFunctionProperty(type: "integer", description: "The amount of proteins in grams of the given food item")
        let params: [String: GPTFunctionProperty] = [
            "food": food,
            "fats": fats,
            "carbs": carbs,
            "proteins": proteins
        
        ]
        
        let functionParam = GPTFunctionParam(type: "object", properties: params, required: ["food", "fats", "carbs", "proteins"])
        let function = GPTFunction(name: "get_macronurients", description: "Get a macronutrines for a given food.", parameters: functionParam)
        
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0125", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
       
        urlRequest.httpBody = jsonData
        
        return urlRequest
    }
    
    func sendPromtToChatGPT(messages: String) async throws ->  MacroResult {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: messages)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        print(String(data: data, encoding: .utf8)!)
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
    
        guard let functionCall = result.choices[0].message.functionCall else {
            throw OpenAIError.noFucntionCall
        }
        guard let argData = functionCall.arguments.data(using: .utf8) else {
            
            throw OpenAIError.unableToConvertStringIntoData
        }
        
       let macro = try JSONDecoder().decode(MacroResult.self, from: argData)
        return macro
        
        
    }
    
   
    
}


