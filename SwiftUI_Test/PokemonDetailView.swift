//
//  PokemonDetailView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    let pokemonDetail: PokemonDetail
    
    var body: some View {
        VStack {
            Text(String(pokemonDetail.id))
            Text(pokemonDetail.name)
                .font(.largeTitle)
                .padding()
            
            if let gifUrl = pokemonDetail.sprites.versions.generationV.blackWhite.animated.front_default, let url = URL(string: gifUrl) {
                WebImage(url: url) // SDWebImageSwiftUI を使用
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else if let imageUrl = pokemonDetail.sprites.front_default, let url = URL(string: imageUrl) {
                // gifが取得できなければ静止画を表示
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
            let height = Double(pokemonDetail.height) * 0.1 // メートルにするため0.1かける
            let weight = Double(pokemonDetail.weight) * 0.1 // キログラムにするため0.1かける
            Text("身長：\(String(format: "%.1f", height))m") // 小数第一位まで表示
            Text("体重：\(String(format: "%.1f", weight))kg") // 小数第一位まで表示
            
            Spacer()
        }
        .padding()
        .navigationTitle("詳細情報")
    }
}
