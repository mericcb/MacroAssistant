import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var context: ModelContext
    @State private var showMenu = false
    
    @State private var selectedTab = 0
    
    @State var selectedOption: SideMenuOptionModel = .macros
    
    @StateObject private var macroManager = MacroManager()
    
    @State private var dailyMacros: [DailyMacro] = []
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
                TabView(selection: $selectedTab) {
                    
                    MacroView(dailyMacros: $dailyMacros)
                        .environmentObject(macroManager)
                    
                            .tag(SideMenuOptionModel.macros.rawValue)
                            .onAppear {
                                selectedOption = .macros
                                updateDailyMacros()
                            }
                    
                    
                    
                    Group {
                        if !dailyMacros.isEmpty {
                            MacroPieChartView(dailyMacros: $dailyMacros)
                        } else {
                            Text("Lütfen önce bir yemek seçin veya ekleyin.")
                        }
                        
                    }
                    .tag(SideMenuOptionModel.performance.rawValue)
                        .onAppear {
                            selectedOption = .performance
                        }
                    
                 
                 
                       
                    
                    
                        SettingView()
                    
                            .tag(SideMenuOptionModel.settings.rawValue)
                            .onAppear {
                                selectedOption = .settings
                            }
                        
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                    SideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)
                    
                
            }
            .navigationTitle("\(selectedOption.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
            
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(Color.primary)
                    }

                }
            }
            
          }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        
        
        .onAppear {
            macroManager.loadMacros(context: context)
                        updateDailyMacros()
        }

        
        .onChange(of: selectedTab) { oldValue, newValue in
                    selectedOption = SideMenuOptionModel(rawValue: newValue) ?? .macros
                }
        .onChange(of: macroManager.macros) { _,_ in
                        updateDailyMacros()
                    }
        
        }
    private func updateDailyMacros() {
        dailyMacros = macroManager.fetchDailyMacros()
            
        }
        
    }


#Preview {
    MainView()
        .modelContainer(for: [Macro.self])
}
