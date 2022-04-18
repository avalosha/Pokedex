//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Álvaro Ávalos Hernández on 13/04/22.
//

import Foundation

class PokedexViewModel {
    public func getCode() {
        let response = Api.makeURLRequest(endpoint: .pokemonApi)
        
        Api.request(url: response) { (data, code) in
            if code != .success {
                print("Code: ",code)
            }
            
            print("Data: ",data)
        }
    }
}
