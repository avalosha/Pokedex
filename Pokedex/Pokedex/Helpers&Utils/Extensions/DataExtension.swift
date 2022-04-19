//
//  DataExtension.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import Foundation

extension Data {
    
    func decodeData<T:Decodable>() -> T? {
        do {
            let response = try JSONDecoder().decode(T.self, from: self)
            return response
        } catch let jsonError {
            print("Failed to decode json: ",jsonError)
            return nil
        }
    }
}
