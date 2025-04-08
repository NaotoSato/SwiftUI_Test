//
//  PokemonViewModel.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import Combine
import Foundation

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
    var name: String // 日本語名に上書きしたいのでvarにしている
    let sprites: Sprites
}

struct Sprites: Decodable {
    let front_default: String? // ポケモンの画像URL
}

struct PokemonSpecies: Decodable {
    let names: [PokemonName]
}

struct PokemonName: Decodable {
    let language: PokemonLanguage
    let name: String
}

struct PokemonLanguage: Decodable {
    let name: String
    let url: String
}

class PokemonListViewModel: ObservableObject {
    @Published var pokemon: PokemonDetail?
    @Published var errorMessage: String?
    @Published var result: Result?
    @Published var pokemonDetails: [PokemonDetail] = []
    
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
                self.fetchPokemonDetails()
            })
            .store(in: &cancellables)
    }
    
    func fetchPokemonDetails() {
        if let result = result {
            for pokemon in result.results {
                api.fetchPokemon(urlString: pokemon.url)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            self.errorMessage = "エラー: \(error.localizedDescription)"
                        case .finished:
                            break
                        }
                    }, receiveValue: { pokemonDetail in
                        self.fetchPokemonSpecies(name: pokemonDetail.name) { japaneseName in
                            DispatchQueue.main.async {
                                if let japaneseName = japaneseName {
                                    // 日本語名が取得できた場合に上書き
                                    var updatedPokemonDetail = pokemonDetail
                                    updatedPokemonDetail.name = japaneseName
                                    self.pokemonDetails.append(updatedPokemonDetail)
                                } else {
                                    // 日本語名が取得できない場合はそのまま追加
                                    self.pokemonDetails.append(pokemonDetail)
                                }
                            }
                        }
                    })
                    .store(in: &cancellables)
            }
        }
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
    
    func fetchPokemonSpecies(name: String, _completion: @escaping (String?) -> Void) {
        api.fetchPokemonSpecies(name: name)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                    _completion(nil)
                case .finished:
                    break
                }
            }, receiveValue: { pokemonSpecies in
                if let japaneseName = pokemonSpecies.names.first(where: { $0.language.name == "ja-Hrkt" }) {
                    _completion(japaneseName.name) // 日本語名をクロージャに渡す
                } else {
                    _completion(nil) // 該当する名前がない場合は nil を返す
                }
                self.errorMessage = nil
            })
            .store(in: &cancellables)
    }
}

