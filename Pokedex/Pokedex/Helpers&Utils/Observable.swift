//
//  Observable.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            listeners.forEach{$0(value)}
        }
    }
    
    private var listeners: [((T) -> Void)] = []
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        self.listeners.append(listener)
    }
}
