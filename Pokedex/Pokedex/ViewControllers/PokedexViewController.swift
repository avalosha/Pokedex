//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var pokedexTableView: UITableView!
    
    private let pokedexViewModel = PokedexViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupBindings()
        
        pokedexViewModel.getCode()
    }

    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func setupTableView() {
        pokedexTableView.delegate = self
        pokedexTableView.dataSource = self
    }
    
    private func setupBindings() {
        pokedexViewModel.pokedex.bind { [weak self] res in
            self?.pokedexTableView.reloadData()
        }
        
        pokedexViewModel.statusCode.bind { [weak self] code in
            print("Code: ",code)
        }
    }
}

extension PokedexViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokedexViewModel.pokedex.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexCell") as! PokedexCell
        let data = pokedexViewModel.pokedex.value[indexPath.row]
        let index = indexPath.row + 1
        cell.setupCell(data: data, index: index)
        
        return cell
    }
    
    
}
