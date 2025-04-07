//
//  PokemonAPI.swift
//  SwiftUI_Test
//
//  Created by 佐藤 直人 on 2025/04/02.
//

import Foundation
import Combine

class PokemonAPI {
    private var cancellables = Set<AnyCancellable>()
    let baseURL = "https://pokeapi.co/api/v2/"
    
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) -> AnyPublisher<Result, Error> {
        let urlString = "\(baseURL)pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data } // レスポンスからデータを取り出す
            .decode(type: Result.self, decoder: JSONDecoder()) // JSONデコード
            .receive(on: DispatchQueue.main) // メインスレッドで受け取る
            .eraseToAnyPublisher() // 返り値を統一する
    }
        
        
    
    func fetchPokemon(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        let urlString = "\(baseURL)pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
            
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data } // レスポンスからデータを取り出す
            .decode(type: PokemonDetail.self, decoder: JSONDecoder()) // JSONデコード
            .receive(on: DispatchQueue.main) // メインスレッドで受け取る
            .eraseToAnyPublisher() // 返り値を統一する
    }
    
}
