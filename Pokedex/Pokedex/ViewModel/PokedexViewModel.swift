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
    private var offset: Int = 0
    private var limit: Int = 10
    
    public func getCode() {
        let params = ["limit":limit, "offset":offset]
        let request = Api.makeURLRequest(endpoint: .pokemonApi,parameters: params)
        
        Api.request(url: request) { (data, code) in
            if code != .success {
                print("Code: ",code)
                self.statusCode.value = code
            }
                        
            guard let response: PokedexResponse = data?.decodeData(), let data = response.results else { return }
            self.pokedex.value = data
            print("items: ",self.pokedex.value.count)
        }
    }
}
