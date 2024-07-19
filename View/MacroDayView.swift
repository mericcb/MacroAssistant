//
//  MacroDayView.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 8.07.2024.
//

import SwiftUI

struct MacroDayView: View {
    
    
    @State var macro: DailyMacro
    
    var body: some View {
       
        HStack {
            VStack (alignment:.leading){
                Text(macro.date.monthAndDay)
                    .font(.title2)
                
                Text(macro.date.year)
                    .font(.title2)
            }
            .frame(width: 60, alignment: .leading)
            Spacer()
            
            HStack {
                VStack {
                    Image("carb")
                        .resizable()
                        .scaledToFit()
                    Text("Carbs")
                        .font(.footnote)

                    Text("\(macro.carbs) g")
                }
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray.opacity(0.1))
                )
                

                
                VStack {
                    Image("fat")
                        .resizable()
                        .scaledToFit()
                    Text("Fats")
                        .font(.footnote)

                    Text("\(macro.fats) g")
                }
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray.opacity(0.1))
                )
                
                

                VStack {
                    Image("protein")
                        .resizable()
                        .scaledToFit()
                    Text("Proteins")
                        .font(.footnote)
                    Text("\(macro.proteins) g")
                }
                .padding()
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray.opacity(0.1))
                )

            }
            Spacer()
        }

    }
}

#Preview {
    MacroDayView(macro: DailyMacro(date: .now, carbs: 123, fats: 50, proteins: 100))
}
