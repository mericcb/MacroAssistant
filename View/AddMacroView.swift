import SwiftUI
import SwiftData

struct AddMacroView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var macroManager: MacroManager
    
    @State private var food = ""
    @State private var date = Date()
    @State private var showAlert = false
    
    @Binding var lastAddedFood: String?
    @Binding var lastAddedCarbs: Int? // Buraya ekledik
    @Binding var lastAddedFats: Int? // Buraya ekledik
    @Binding var lastAddedProteins: Int?
    
    var body: some View {
        ZStack(alignment:.topTrailing) {
            
            Color("background")
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Add Macro")
                    .font(.title)
                
                TextField("What did you eat", text: $food)
                    .padding()
                    .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke()
                    
                    )
                DatePicker("Date", selection: $date)
                
                Button{
                    if food.count > 2 {
                        sendItemToChatGPT()
                        
                    }
                } label: {
                    Text("Done")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(uiColor: .label))
                        
                        )
                }
                
            }
            .padding(.top, 24)
            .padding(.horizontal)
            .alert("Oops", isPresented: $showAlert) {
                Text("OK")
            } message: {
                Text("We were unable to verify the food item. Please make sure you enter a valid food item and try again.")
            }
            Button("", systemImage: "x.circle.fill") {
                dismiss()
            }
            .font(.title)
            .foregroundStyle(.primary)
        }

    }
    
    private func sendItemToChatGPT() {
        Task {
            do {
                let result = try await OpenAIService.shared.sendPromtToChatGPT(messages: food)
                saveMacro(result)
                dismiss()
            } catch {
                if let openAIError = error as? OpenAIError {
                    switch openAIError {
                    case.noFucntionCall:
                        showAlert = true
                    case.unableToConvertStringIntoData:
                        print(error.localizedDescription)
                    }
                } else {
                    print(error.localizedDescription)
                }
            }
        }

    }
    
    private func saveMacro(_ result: MacroResult) {
        let macro = Macro(food: result.food, createdAt: .now, date: date, fats: result.fats, carbs: result.carbs, proteins: result.proteins)
        macroManager.addMacro(macro, context: modelContext)
        modelContext.insert(macro)
        lastAddedFood = macro.food
        lastAddedFats = macro.fats
        lastAddedCarbs = macro.carbs
        lastAddedProteins = macro.proteins
        print(macroManager.macros)
        
    }
}

#Preview {
    AddMacroView(lastAddedFood: .constant(nil), lastAddedCarbs: .constant(nil), lastAddedFats: .constant(nil), lastAddedProteins: .constant(nil))
        .environmentObject(MacroManager())
}
