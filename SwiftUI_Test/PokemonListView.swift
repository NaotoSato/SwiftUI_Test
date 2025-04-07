//
//  PokemonQuizView.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var pokemonName: String = ""
    let pokemonMaxId = 1300
    var onDismiss: () -> Void
    
    var body: some View {
        VStack {
            Text("ポケモン図鑑")
            if (viewModel.pokemonDetails.isEmpty == false) {
                let rows: [[PokemonDetail]] = viewModel.pokemonDetails.chunked(by: 3)
                ScrollView(.vertical, showsIndicators: true) {
                    Grid(alignment: .top, horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(rows.enumerated().map({ $0 }), id: \.0) { index, row in
                            GridRow {
                                createPokemonRow(row: row)
                            }
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("エラー：\(errorMessage)")
            }
            
            Button("閉じる") {
                onDismiss()
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
        .onAppear() {
            viewModel.fetchPokemonList()
        }
    }
    
    func createPokemonRow(row: [PokemonDetail]) -> some View {
        ForEach(row, id: \.name) { pokemon in
            VStack {
                Text(pokemon.name.capitalized)
                    .font(.subheadline)
                    .padding(.vertical)
                if let imageUrl = pokemon.sprites.front_default, let url = URL(string: imageUrl) {
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



#Preview {
    PokemonListView() {}
}
