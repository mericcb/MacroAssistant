import SwiftUI

struct MacroHeaderView: View {
    
    @Binding var carbs: Int
    @Binding var fats: Int
    @Binding var proteins: Int
    var body: some View {
        
        HStack {
            Spacer()
            
            VStack {
                Image("carb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Text("Carbs")
                Text("\(carbs) g")
            }
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.3))
            )
            Spacer()

            
            VStack {
                Image("fat")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Text("Fats")
                Text("\(fats) g")
            }
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.3))
            )
            
            Spacer()

            VStack {
                Image("protein")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                Text("Proteins")
                Text("\(proteins) g")
            }
            .padding()
            .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.gray.opacity(0.3))
            )
            
            Spacer()

        }
    }
}

#Preview {
    MacroHeaderView(carbs: .constant(30), fats: .constant(40), proteins: .constant(50))
}
