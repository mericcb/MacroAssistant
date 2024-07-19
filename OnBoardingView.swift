//
//  OnBoardingView.swift
//  AIMacroAssistant
//
//  Created by Meriç Cem Baysar on 14.07.2024.
//

import SwiftUI

struct OnBoardingView: View {
    @Binding var shoulShowOnboarding : Bool
    @State private var currentPage = 0
    
    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Hoş Geldiniz", description: "AIMacroAssistant ile makrolarınızı kolayca takip edin.", imageName: "chart.pie.fill"),
        OnboardingPage(title: "Günlük Takip", description: "Her gün için makrolarınızı girin ve ilerleyişinizi görün.", imageName: "calendar"),
        OnboardingPage(title: "Analiz", description: "Detaylı grafikler ve raporlarla beslenmenizi analiz edin.", imageName: "chart.bar.fill")
    ]
    
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    VStack {
                        Image(systemName: page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.white)
                            .shadow(color: .black.opacity(0.4), radius: 10, x: 10, y: 10)
                        
                        Text(page.title)
                            .font(.title)
                            .bold()
                            .padding()
                        
                        Text(page.description)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        if page.id == pages.last?.id {
                            Button("Başlayın") {
                                shoulShowOnboarding = false
                            }
                            .padding()
                            .background(Color("button"))
                            .foregroundStyle(Color(.anylabel))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                        }
                    }
                    .tag(pages.firstIndex(of: page)!)
                }
            }
            .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .animation(.easeInOut, value: currentPage)
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage = pages.count - 1
                        }
                        
                    }
                    .padding()
                    .background(Color("button"))
                    .foregroundStyle(Color(.anylabel))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }
                .padding()
                Spacer()
            }
            
            
        }
        .background(Color("background"))
    }
}

#Preview {
    OnBoardingView(shoulShowOnboarding: .constant(true))
}


struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}
