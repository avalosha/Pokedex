//
//  ViewController.swift
//  Pokedex
//
//  Created by Álvaro Ávalos Hernández on 13/04/22.
//

import UIKit

class ViewController: UIViewController {

    private let pokedexViewModel = PokedexViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokedexViewModel.getCode()
    }


}
