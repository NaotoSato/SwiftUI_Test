//
//  PokemonQuizView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    let pokemonMaxId = 1300
    var onDismiss: () -> Void
    @State var currentOffset = 0
    let limit = 20
    
    // ヘッダー
    var header: some View {
        ZStack(alignment: .leadingFirstTextBaseline) {
            Button("閉じる") {
                onDismiss()
            }
            .font(.headline)
            .padding()
            .pokemonButtonStyle()
            .offset(x: 20)
            
            Text("ポケモン図鑑")
                .frame(maxWidth: .infinity)
                .font(.title)
                .padding()
                
        }
        .frame(maxWidth: .infinity)
        .background(Color.originalLightGreen)
        
    }
    
    // ポケモンリスト
    var list: some View {
        VStack {
            if (viewModel.pokemonDetailDtos.isEmpty == false) {
                let detailRows: [[PokemonDetailDto]] = viewModel.pokemonDetailDtos.chunked(by: 3)
                ScrollView(.vertical, showsIndicators: true) {
                    Grid(alignment: .top, horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(detailRows.enumerated().map({ $0 }), id: \.0) { index, row in
                            GridRow {
                                createPokemonRow(row: row)
                            }
                        }
                    }
                }
                .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("エラー：\(errorMessage)")
            }
        }
    }
    
    // フッター
    var footer: some View {
        HStack {
            Spacer()
            
            Button("前の20件") {
                // 前が存在する場合リストを切り替える
                if (currentOffset >= limit) {
                    currentOffset -= limit
                    viewModel.fetchPokemonList(offset: currentOffset)
                }
            }
            .padding()
            .pokemonButtonStyle()
            
            Spacer()
            
            Button("次の20件") {
                // 次が存在する場合リストを切り替える
                if (viewModel.totalCount > 0 && (viewModel.totalCount / limit) * limit > currentOffset) {
                    currentOffset += limit
                    viewModel.fetchPokemonList(offset: currentOffset)
                }
            }
            .padding()
            .pokemonButtonStyle()
            
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    header
                    Spacer()
                    list
                    Spacer()
                    footer
                }
                .onAppear() {
                    viewModel.fetchPokemonList(offset: currentOffset)
                }
            }
            .pokemonBackground()
        }
    }
    
    // 一行分のリストを作成
    func createPokemonRow(row: [PokemonDetailDto]) -> some View {
        ForEach(row, id: \.name) { pokemonDetailDto in
            NavigationLink(destination: PokemonDetailView(pokemonDetailDto: pokemonDetailDto)) {
                VStack {
                    Text(String(pokemonDetailDto.id))
                        .padding()
                    Text(pokemonDetailDto.name)
                        .font(.subheadline)
                    if let imageUrl = pokemonDetailDto.sprites.front_default, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
                .cornerRadius(10)
                .shadow(radius: 3, x: 10, y: 10)
            }
        }
    }
    
    
}



#Preview {
    PokemonListView() {}
}
