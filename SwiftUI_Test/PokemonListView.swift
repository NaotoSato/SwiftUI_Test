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
            if let result = viewModel.result {
                ScrollView(.vertical, showsIndicators: true) {
                    Grid(alignment: .top, horizontalSpacing: 28, verticalSpacing: 32) {
                        let rows = result.results.chunked(by: 3)
                        ForEach(rows.enumerated().map({ $0 }), id: \.0) { index, row in
                            GridRow {
                                ForEach(row, id: \.name) { pokemon in
                                    Text(pokemon.name.capitalized)
                                }
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
        

//        Button("検索") {
//            viewModel.fetchPokemon(name: pokemonName)
//        }
//        .padding()
//
//        if let pokemon = viewModel.pokemon {
//            VStack {
//                Text("名前: \(pokemon.name.capitalized)")
//                    .font(.title)
//                if let imageUrl = pokemon.sprites.front_shiny, let url = URL(string: imageUrl) {
//                    AsyncImage(url: url) { image in
//                        image.resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                    } placeholder: {
//                        ProgressView()
//                    }
//                }
//            }
//        } else if let errorMessage = viewModel.errorMessage {
//            Text(errorMessage)
//                .foregroundColor(.red)
//        }
    }
}

#Preview {
    PokemonListView() {}
}
