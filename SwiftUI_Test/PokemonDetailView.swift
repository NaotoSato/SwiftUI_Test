//
//  PokemonDetailView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/08.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    let pokemonDetailDto: PokemonDetailDto
    
    var body: some View {
        VStack {
            Text("No.\(String(pokemonDetailDto.id))")
            Text(pokemonDetailDto.name)
                .font(.largeTitle)
                .padding()
            
            if let gifUrl = pokemonDetailDto.sprites.versions.generationV.blackWhite.animated.front_default, let url = URL(string: gifUrl) {
                WebImage(url: url) // SDWebImageSwiftUI を使用
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            } else if let imageUrl = pokemonDetailDto.sprites.front_default, let url = URL(string: imageUrl) {
                // gifが取得できなければ静止画を表示
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } placeholder: {
                    ProgressView()
                }
            }
            Text(pokemonDetailDto.genus)
                .padding()
            let height = Double(pokemonDetailDto.height) * 0.1 // メートルにするため0.1かける
            let weight = Double(pokemonDetailDto.weight) * 0.1 // キログラムにするため0.1かける
            Text("たかさ：\(String(format: "%.1f", height))m") // 小数第一位まで表示
            Text("おもさ：\(String(format: "%.1f", weight))kg") // 小数第一位まで表示
            Text(pokemonDetailDto.flavorText)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("詳細情報")
    }
}
