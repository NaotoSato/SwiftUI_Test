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
    
    // カードの外側の枠
    var outsideFrame: some View {
        Rectangle()
            .frame(width: 340, height: 540)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .fill(.originalGray)
            )
            .mask {
                RoundedRectangle(cornerRadius: 10)
            }
            .shadow(radius: 3, x: 10, y: 10)
    }
    
    // カードの内側の枠
    var insideFrame: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .frame(width: 320, height: 520)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .fill(pokemonDetailDto.types.first?.color ?? .white)
                )
                .mask {
                    RoundedRectangle(cornerRadius: 10)
                }
            // ポケモン情報
            pokemonInfo
        }
    }
    
    //　カード台紙
    var cardBoard: some View {
        ZStack {
            outsideFrame
            insideFrame
        }
    }
    
    // ポケモン画像
    var pokemonImage: some View {
        VStack {
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
        }
    }
    
    // ポケモン情報
    var pokemonInfo: some View {
        ZStack {
            Rectangle()
                .frame(width: 320, height: 160)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .fill(.white)
                )
                .mask {
                    RoundedRectangle(cornerRadius: 10)
                }
            
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
    
    var body: some View {
        ZStack(alignment: .top) {
            // カード台紙
            cardBoard
            
            // ポケモン画像
            pokemonImage
                .offset(y: -40) // 少し上にずらす
        }
        .navigationTitle("詳細情報")
    }
}

#Preview {
    let dto = PokemonDetailDto(
        id: 1,
        name: "リザードン",
        height: 1,
        weight: 1,
        sprites: Sprites.init(
            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/9.png",
            other: OtherSprites.init(
                showdown: ShowdownSprites.init(
                    front_default: ""
                )
            ),
            versions: VersionSprites.init(
                generationV: GenerationVSprites.init(
                    blackWhite: BlackWhiteSprites.init(
                        animated: AnimatedSprites.init(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/6.gif"
                        )
                    )
                )
            )
        ),
        types: [.fire],
        genus: "かえんポケモン",
        flavorText: "あああああああああああああああ\nああああああああああああああ\nああああ")
    
    PokemonDetailView(
        pokemonDetailDto: dto
    )
}
