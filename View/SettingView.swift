//
//  SettingView.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 18.07.2024.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.modelContext) private var modelContext
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            
            Form {
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Text("Dark Mode")
                    }
                } header: {
                    Text("Screen")
                }
                .listRowBackground(Color.white.opacity(0.4))
                
                Section(header: Text("Data")) {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Text("Tüm Verileri Sıfırla")
                            .foregroundColor(.red)
                    }
                    .listRowBackground(Color.white.opacity(0.4))
                    
                    
                    
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .alert("Verileri sıfırla", isPresented: $showingResetAlert) {
                    Button("İptal", role: .cancel) { }
                    Button("Sıfırla", role: .destructive) {
                        resetAllData()
                    }
                } message: {
                    Text("Tüm verileriniz silinecek bu işlem geri alınamaz.")
                }
                
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }

    }
    
    private func resetAllData() {
        
        do {
            try modelContext.delete(model: Macro.self)
            print("Tüm veriler başarıyla silindi")
        }catch {
            print("Veri silme hatası: \(error.localizedDescription)")
        }
    }
}


#Preview {
    SettingView()
}
