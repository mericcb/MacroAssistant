import SwiftUI
import SwiftData






struct MacroView: View {
    
    @Environment(\.modelContext) var modelContext
    @State var carbs = 0
    @State var fats = 0
    @State var proteins = 0
    
    @Query() var macros: [Macro]
    @Binding var dailyMacros: [DailyMacro]
    
    
    @State var showTextField = false
    @State var showMenu = false
    @State var food = ""
    @State private var selectedMacro: Macro?
    
    @State var lastAddedFood: String?
    @State private var lastAddedCarbs: Int?
    @State private var lastAddedFats: Int?
    @State private var lastAddedProteins: Int?
    
    @EnvironmentObject var macroManager: MacroManager
    
    
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
                        
                        MacroHeaderView(carbs: $carbs, fats: $fats, proteins: $proteins)
                            .padding()
                        
                        if let lastAddedFood = lastAddedFood {
                                Text("Last Added Food: \(lastAddedFood)")
                                .font(.headline)
                                .padding()
                            
                            HStack{
                                if let lastAddedFats = lastAddedFats,
                                   let lastAddedCarbs = lastAddedCarbs,
                                   let lastAddedProteins = lastAddedProteins {
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
                    AddMacroView(lastAddedFood: $lastAddedFood, lastAddedCarbs: $lastAddedCarbs, lastAddedFats: $lastAddedFats, lastAddedProteins: $lastAddedProteins)
                        .presentationDetents([.fraction(0.4)])
                        .environmentObject(macroManager)
                }
                .onDisappear {
                    if let lastMacro = macros.last {
                            lastAddedFood = lastMacro.food
                    }
                }
                .onAppear {
                    fetchDailyMacros()
                    fetchTodaysMacro()
                }
                .onChange(of: macros) { _, _ in
                    fetchDailyMacros()
                    fetchTodaysMacro()
            }
            }

        
        
    }
    
    
    
    private func fetchDailyMacros() {
        let dates: Set<Date> = Set(macros.map({Calendar.current.startOfDay(for: $0.date) }))
        
        var dailyMacros = [DailyMacro]()
        for date in dates {
            let filterMacros = macros.filter({ Calendar.current.startOfDay(for: $0.date) == date})
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            let proteins: Int = filterMacros.reduce(0, { $0 + $1.proteins })
            
            let macro = DailyMacro(date: date, carbs: carbs, fats: fats, proteins: proteins)
            dailyMacros.append(macro)
        }
        
        self.dailyMacros = dailyMacros.sorted(by: { $0.date > $1.date})

    }
    
    private func fetchTodaysMacro() {
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

#Preview {
    MacroView(dailyMacros: .constant([]))
}
