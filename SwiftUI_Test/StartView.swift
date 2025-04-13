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
            Button {
                isShowingPokemonListView = true
            } label: {
                Text("ポケモン図鑑")
                    .font(.headline)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $isShowingPokemonListView) {
                PokemonListView() {
                    isShowingPokemonListView = false
                }
            }
            .pokemonButtonStyle()
            .padding()
            
            Button {
                isShowingQuizView = true
            } label: {
                Text("動物クイズ(SwiftUIチュートリアル)")
                    .font(.headline)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
            }
            .fullScreenCover(isPresented: $isShowingQuizView) {
                QuizView()
            }
            .pokemonButtonStyle()
            .padding()

        }
        .pokemonBackground()
    }
}

#Preview {
    StartView()
}
