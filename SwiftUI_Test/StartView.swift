//
//  ContentView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/03/31.
//

import SwiftUI

struct StartView: View {
    @State var isShowingPokemonListView = false
    @State var isShowingQuizView = false
    
    var body: some View {
        VStack {
            Button("ポケモン図鑑") {
                isShowingPokemonListView = true
            }
            .fullScreenCover(isPresented: $isShowingPokemonListView) {
                PokemonListView() {
                    isShowingPokemonListView = false
                }
            }
            
            Button("動物クイズ") {
                isShowingQuizView = true
            }
            .fullScreenCover(isPresented: $isShowingQuizView) {
                QuizView()
            }

        }
        .padding()
        
        
//        VStack {
//            Spacer()
//            Text("どうぶつ\nクイズ！")
//                .font(.system(size: 70).bold())
//                .foregroundStyle(.originalYellow)
//                .stroke(color: .originalGreen, width: 5)
//            Spacer()
//            Button {
//                isShowingQuizView = true
//            } label: {
//                Image(.startButton)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: .infinity)
//            }
//            .fullScreenCover(isPresented: $isShowingQuizView) {
//                QuizView()
//            }
//        }
//        .padding()
//        .backgroundImage()
    }
}

#Preview {
    StartView()
}
