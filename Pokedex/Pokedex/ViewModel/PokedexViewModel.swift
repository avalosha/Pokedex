//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Álvaro Ávalos Hernández on 13/04/22.
//

import Foundation

class PokedexViewModel {
    public var statusCode = Observable(CodeResponse.success)
    public var pokedex = Observable([Pokemons]())
    private var pokemons = [Pokemons]()
    private var offset: Int {
        get { pokemons.count }
    }
    private var limit: Int = 10
    
    public func getCode() {
        let params = ["limit":limit, "offset":offset]
        print("Offset: ",offset)
        let request = Api.makeURLRequest(endpoint: .pokemonApi, parameters: params)
        
        Api.request(url: request) { (data, code) in
            if code != .success {
                print("Code: ",code)
                self.statusCode.value = code
            }
                        
            guard let response: PokedexResponse = data?.decodeData(), let results = response.results else { return }
            
            self.pokedex.value = results
            self.pokemons += results
        }
    }
}
