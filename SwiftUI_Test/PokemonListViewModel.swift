//
//  PokemonViewModel.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import Combine
import Foundation
import SwiftUI

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
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [Types]
}

struct PokemonDetailDto {
    let id: Int
    let name: String // 基本日本語。取得できなければ英語
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [PokemonListViewModel.TypeKind]
    let genus: String
    let flavorText: String
}

struct Types: Decodable {
    let slot: Int
    let type: _Type
}

struct _Type: Decodable {
    let name: String
    let url: String
}

struct Sprites: Decodable {
    let front_default: String? // ポケモンの画像URL
    let other: OtherSprites
    let versions: VersionSprites
}

struct OtherSprites: Decodable {
    let showdown: ShowdownSprites
}

struct ShowdownSprites: Decodable {
    let front_default: String?
}

struct VersionSprites: Decodable {
    let generationV: GenerationVSprites
    
    enum CodingKeys: String, CodingKey {
        case generationV = "generation-v"
    }
}

struct GenerationVSprites: Decodable {
    let blackWhite: BlackWhiteSprites
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

struct BlackWhiteSprites: Decodable {
    let animated: AnimatedSprites
}

struct AnimatedSprites: Decodable {
    let front_default: String?
}

struct PokemonSpecies: Decodable {
    let names: [PokemonName]
    let genera: [PokemonGenera]
    let flavor_text_entries: [PokemonFlavorText]
}

struct PokemonName: Decodable {
    let language: PokemonLanguage
    let name: String
}

struct PokemonGenera: Decodable {
    let genus: String
    let language: PokemonLanguage
}

struct PokemonFlavorText: Decodable {
    let flavor_text: String
    let language: PokemonLanguage
}

struct PokemonLanguage: Decodable {
    let name: String
    let url: String
}

class PokemonListViewModel: ObservableObject {
    // ポケモンのタイプ
    enum TypeKind: String {
        case normal, fighting, flying, poison, ground, rock, bug, ghost, steel, fire, water, grass, electric, psychic, ice, dragon, dark, fairy
        
        var name: String {
            switch self {
                case TypeKind.normal:
                    return "ノーマル"
                case .fighting:
                    return "かくとう"
                case .flying:
                    return "ひこう"
                case .poison:
                    return "どく"
                case .ground:
                    return "じめん"
                case .rock:
                    return "いわ"
                case .bug:
                    return "むし"
                case .ghost:
                    return "ゴースト"
                case .steel:
                    return "はがね"
                case .fire:
                    return "ほのお"
                case .water:
                    return "みず"
                case .grass:
                    return "くさ"
                case .electric:
                    return "でんき"
                case .psychic:
                    return "エスパー"
                case .ice:
                    return "こおり"
                case .dragon:
                    return "ドラゴン"
                case .fairy:
                    return "フェアリー"
                default:
                    return ""
            }
        }
        
        var color: Color {
            Color(self.rawValue)
        }
    }
    
    @Published var errorMessage: String?
    @Published var pokemonDetails: [PokemonDetail] = []
    @Published var pokemonDetailDtos: [PokemonDetailDto] = []
    @Published var totalCount: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    private let api = PokemonAPI()
    
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) {
        self.pokemonDetailDtos = []
        api.fetchPokemonList(limit: limit, offset: offset)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "エラー: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { result in
                self.totalCount = result.count
                self.errorMessage = nil
                self.fetchPokemonDetails(result: result)
            })
            .store(in: &cancellables)
    }
    
    func fetchPokemonDetails(result: Result) {
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
                    self.fetchPokemonSpecies(name: pokemonDetail.name) { pokemonSpecies in
                        DispatchQueue.main.async {
                            var name = pokemonDetail.name
                            var genus = ""
                            var flavorText = ""
                            if let pokemonSpecies = pokemonSpecies {
                                // 日本語名の取得
                                if let japaneseName = pokemonSpecies.names.first(where: { $0.language.name == "ja-Hrkt" }) {
                                    name = japaneseName.name
                                }
                                // 日本語分類の取得
                                if let japaneseGenus = pokemonSpecies.genera.first(where: { $0.language.name == "ja-Hrkt" }) {
                                    genus = japaneseGenus.genus
                                }
                                // 日本語説明文の取得
                                if let japaneseFlavorText = pokemonSpecies.flavor_text_entries.first(where: { $0.language.name == "ja-Hrkt" }) {
                                    flavorText = japaneseFlavorText.flavor_text
                                }
                            }
                            // タイプ
                            let types = pokemonDetail.types.compactMap { TypeKind(rawValue: $0.type.name) }
                            // DTOに詰め込み直す
                            let pokemonDetailDto = PokemonDetailDto(id: pokemonDetail.id, name: name, height: pokemonDetail.height, weight: pokemonDetail.weight, sprites: pokemonDetail.sprites, types: types, genus: genus, flavorText: flavorText)
                            self.pokemonDetailDtos.append(pokemonDetailDto)
                            // 並び順がバラバラになることがあるのでソートしておく
                            self.pokemonDetailDtos.sort(by: {$0.id < $1.id})
                        }
                    }
                })
                .store(in: &cancellables)
        }
    }
    
    func fetchPokemonSpecies(name: String, _completion: @escaping (PokemonSpecies?) -> Void) {
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
                _completion(pokemonSpecies)
            })
            .store(in: &cancellables)
    }
}

