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
        ZStack {
            // 大外の枠
            Rectangle()
                .foregroundColor(.originalGray)
                .frame(width: 340, height: 590) // 高さを調整して2つの四角を統合
                .border(Color.black, width: 1)
                .cornerRadius(10)
                .shadow(radius: 3, x: 10, y: 10)
            
            // 中の枠
            Rectangle()
                .foregroundColor(pokemonDetailDto.types.first?.color ?? .white)
                .frame(width: 320, height: 570) // 高さを調整して2つの四角を統合
                .border(Color.black, width: 1)
                .cornerRadius(10)
            
            VStack {
                // ポケモン画像
                if let gifUrl = pokemonDetailDto.sprites.versions.generationV.blackWhite.animated.front_default, let url = URL(string: gifUrl) {
                    WebImage(url: url) // SDWebImageSwiftUI を使用
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                } else if let imageUrl = pokemonDetailDto.sprites.front_default, let url = URL(string: imageUrl) {
                    // gifが取得できなければ静止画を表示
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 320, height: 160)
                        .border(Color.black, width: 1)
                        .cornerRadius(10)
                    
                    VStack {
                        HStack {
                            // 名前
                            Text(pokemonDetailDto.name)
                                .font(.headline)
                                .padding()
                            Spacer()
                            // タイプ
                            ForEach(pokemonDetailDto.types, id: \.self) { _type in
                                Text(_type.name)
                                    .frame(width: 80, height: 20)
                                    .background(_type.color, in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .frame(width: 315, height: 20)
                        
                        // 分類
                        Text(pokemonDetailDto.genus)
                        
                        HStack {
                            // たかさ、おもさ
                            let height = Double(pokemonDetailDto.height) * 0.1 // メートルにするため0.1かける
                            let weight = Double(pokemonDetailDto.weight) * 0.1 // キログラムにするため0.1かける
                            Text("たかさ：\(String(format: "%.1f", height))m") // 小数第一位まで表示
                            Text("おもさ：\(String(format: "%.1f", weight))kg") // 小数第一位まで表示
                        }
                        .frame(width: 315, height: 15)
                        
                        Divider()
                            .frame(width: 320)
                        // 説明
                        Text(pokemonDetailDto.flavorText)
                    }
                }

            }
        }
        .navigationTitle("詳細情報")
    }
}
