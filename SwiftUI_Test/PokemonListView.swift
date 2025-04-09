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
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("ポケモン図鑑")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.originalLightGreen)
                Spacer()
                if (viewModel.pokemonDetails.isEmpty == false) {
                    let detailRows: [[PokemonDetail]] = viewModel.pokemonDetails.chunked(by: 3)
                    ScrollView(.vertical, showsIndicators: true) {
                        Grid(alignment: .top, horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(detailRows.enumerated().map({ $0 }), id: \.0) { index, row in
                                GridRow {
                                    createPokemonRow(row: row)
                                }
                            }
                        }
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    Text("エラー：\(errorMessage)")
                }
                Spacer()
                HStack {
                    Button("前の20件") {
                        // 前が存在する場合リストを切り替える
                        if (currentOffset >= limit) {
                            currentOffset -= limit
                            viewModel.fetchPokemonList(offset: currentOffset)
                        }
                    }
                    .padding()
                    
                    Button("閉じる") {
                        onDismiss()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    Button("次の20件") {
                        // 次が存在する場合リストを切り替える
                        if (viewModel.totalCount > 0 && (viewModel.totalCount / limit) * limit > currentOffset) {
                            currentOffset += limit
                            viewModel.fetchPokemonList(offset: currentOffset)
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .onAppear() {
                viewModel.fetchPokemonList(offset: currentOffset)
            }
        }
    }
    
    func createPokemonRow(row: [PokemonDetail]) -> some View {
        ForEach(row, id: \.name) { pokemonDetail in
            NavigationLink(destination: PokemonDetailView(pokemonDetail: pokemonDetail)) {
                VStack {
                    Text(String(pokemonDetail.id))
                    Text(pokemonDetail.name)
                        .font(.subheadline)
                        .padding(.vertical)
                    if let imageUrl = pokemonDetail.sprites.front_default, let url = URL(string: imageUrl) {
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
            }
        }
    }
    
    
}



#Preview {
    PokemonListView() {}
}
