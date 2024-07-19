//
//  SideMenuHeader.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 10.07.2024.
//

import SwiftUI

struct SideMenuHeader: View {
    var body: some View {
        
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.vertical)
            
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Meriç Cem Baysar")
                    .font(.subheadline)
                
                Text("mericcembaysar2002@hotmail.com")
                    .font(.footnote)
                    .tint(.gray)
                
                
                
            }
        }
        
    }
}

#Preview {
    SideMenuHeader()
}
