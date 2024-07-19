import SwiftUI
import Charts

struct MacroPieChartView: View {
    @Binding var dailyMacros: [DailyMacro]
    @State private var selectedDate: Date = Date()
    
    private var selectedDailyMacro: DailyMacro? {
        dailyMacros.first { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private var macroData: [(String, Double)] {
        guard let dailyMacro = selectedDailyMacro else { return [] }
        return [
            ("Yağlar", Double(dailyMacro.fats)),
            ("Karbonhidratlar", Double(dailyMacro.carbs)),
            ("Proteinler", Double(dailyMacro.proteins))
        ]
    }
    
    var body: some View {
        
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack(spacing: 10) {
                    DatePicker("Tarih Seçin", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(height: 300)  // Sabit yükseklik
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Text("Günlük Makrolar: \(selectedDate, formatter: dateFormatter)")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    ZStack {
                        if selectedDailyMacro != nil {
                            Chart(macroData, id: \.0) { macroType, value in
                                SectorMark(
                                    angle: .value("Değer", value),
                                    innerRadius: .ratio(0.618),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(by: .value("Macro", macroType))
                            }
                        } else {
                            Text("Bu tarih için veri yok")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(height: 200)  // Sabit yükseklik
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        MacroLegendRow(color: .blue, label: "Yağlar", value: Int(macroData.first(where: { $0.0 == "Yağlar" })?.1 ?? 0), total: selectedDailyMacro?.totalMacros ?? 0)
                        MacroLegendRow(color: .green, label: "Karbonhidratlar", value: Int(macroData.first(where: { $0.0 == "Karbonhidratlar" })?.1 ?? 0), total: selectedDailyMacro?.totalMacros ?? 0)
                        MacroLegendRow(color: .orange, label: "Proteinler", value: Int(macroData.first(where: { $0.0 == "Proteinler" })?.1 ?? 0), total: selectedDailyMacro?.totalMacros ?? 0)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
            
        }
    }

struct MacroLegendRow: View {
    let color: Color
    let label: String
    let value: Int
    let total: Int
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(label)
                .font(.subheadline)
            Spacer()
            if total > 0 {
                Text("\(value)g (\(Int((Double(value) / Double(total)) * 100))%)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            } else {
                Text("\(value)g (0%)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
    }
}

extension DailyMacro {
    var totalMacros: Int {
        return carbs + fats + proteins
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}

#Preview {
    MacroPieChartView(dailyMacros: .constant([
        DailyMacro(date: Date(), carbs: 30, fats: 10, proteins: 20),
        DailyMacro(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, carbs: 50, fats: 20, proteins: 10)
    ]))
}
