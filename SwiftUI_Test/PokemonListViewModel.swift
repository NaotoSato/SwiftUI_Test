//
//  PokemonViewModel.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import Combine

struct Result: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Decodable {
    let name: String
    let url: String
}

struct PokemonDetail: Decodable {
    let name: String
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String? // ポケモンの画像URL
}

class PokemonListViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    @Published var errorMessage: String?
    @Published var result: Result?
    
    private var cancellables = Set<AnyCancellable>()
    private let api = PokemonAPI()
    
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) {
        api.fetchPokemonList(limit: limit, offset: offset)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { result in
                self.result = result
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
    
    func fetchPokemon(id: Int) {
        api.fetchPokemon(id: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { pokemon in
                self.pokemon = pokemon
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}

