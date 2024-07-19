import SwiftUI
import SwiftData






struct MacroView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query() var macros: [Macro]
    @Binding var dailyMacros: [DailyMacro]
    
    @StateObject var viewModel: MacroViewModel
    
    @State var showTextField = false
    @State var showMenu = false
    @State var food = ""
    @State private var selectedMacro: Macro?
    @EnvironmentObject var macroManager: MacroManager
    
    init(dailyMacros: Binding<[DailyMacro]>) {
            self._dailyMacros = dailyMacros
            self._viewModel = StateObject(wrappedValue: MacroViewModel())
        }
    
    var body: some View {
            #if DEBUG
            NavigationStack {
                content
            }
            #else
            content
            #endif
        }
    
    
    @ViewBuilder
    private var content: some View {
        
       
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        
                        Text("Today's Macros")
                            .font(.title)
                            .padding()
                        
                        MacroHeaderView(carbs: $viewModel.carbs, fats: $viewModel.fats, proteins: $viewModel.proteins)
                            .padding()
                        
                        if let lastAddedFood = viewModel.lastAddedFood {
                                Text("Last Added Food: \(lastAddedFood)")
                                .font(.headline)
                                .padding()
                            
                            HStack{
                                if let lastAddedFats = viewModel.lastAddedFats,
                                   let lastAddedCarbs = viewModel.lastAddedCarbs,
                                   let lastAddedProteins = viewModel.lastAddedProteins {
                                    Text("carbs:\(lastAddedCarbs)")
                                    Text("fats:\(lastAddedFats)")
                                    Text("proteins:\(lastAddedProteins)")
                                        
                                }
                            }
                            .font(.headline)
                            .padding()
                            
                            }
                        
                        VStack(alignment: .leading) {
                            Text("Previous")
                                .font(.title)
                            
                            ForEach(dailyMacros) { macro in
                                MacroDayView(macro: macro)
                            }
                            
                        }
                        .padding()
                        
                        
                        
                       
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                }
                
                
                .scrollIndicators(.hidden)
                .toolbar {
                                    
                    ToolbarItem {
                        Button(action: {
                            showTextField = true
                            print(dailyMacros)
                        }, label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .background(
                                Circle()
                                    .foregroundStyle(Color(.label))
                                    .frame(width: 30, height: 30)
                                    
                                )
                                .foregroundStyle(Color(.systemBackground))
                        })
                    }
                    
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .sheet(isPresented: $showTextField) {
                    AddMacroView(lastAddedFood: $viewModel.lastAddedFood, lastAddedCarbs: $viewModel.lastAddedCarbs, lastAddedFats: $viewModel.lastAddedFats, lastAddedProteins: $viewModel.lastAddedProteins)
                        .presentationDetents([.fraction(0.4)])
                        .environmentObject(macroManager)
                }
                .onDisappear {
                    if let lastMacro = macros.last {
                        viewModel.lastAddedFood = lastMacro.food
                    }
                }
                .onAppear {
                    viewModel.fetchDailyMacros(macros: macros)
                    viewModel.fetchTodaysMacro(from: dailyMacros)
                }
                .onChange(of: dailyMacros) { _, newDailyMacros in
                    viewModel.fetchTodaysMacro(from: newDailyMacros)
            }
            }

        
        
    }
    
    
    
}

#Preview {
    MacroView(dailyMacros: .constant([]))
}
