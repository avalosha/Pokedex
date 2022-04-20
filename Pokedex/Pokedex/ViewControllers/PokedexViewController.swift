//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pokedexTableView: UITableView!
    
    @IBOutlet weak var navBarConstraint: NSLayoutConstraint!
    
    private let pokedexViewModel = PokedexViewModel()
    private var pokemons = [Pokemons]() {
        didSet {
            pokedexTableView.reloadData()
        }
    }
    private var isLoading = true
    private var noMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSearch()
        setupTableView()
        setupBindings()
        
        pokedexViewModel.getCode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.bringSubviewToFront(self.navBarView)
        let heightOriginalNavBar = (self.navigationController?.navigationBar.frame.height ?? 0.0) + UIApplication.shared.statusBarFrame.size.height
        self.navBarConstraint.constant = heightOriginalNavBar < 65.0 ? 65.0 : heightOriginalNavBar
    }
    
    private func setupSearch() {
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
    }
    
    private func setupTableView() {
        pokedexTableView.delegate = self
        pokedexTableView.dataSource = self
    }
    
    private func setupBindings() {
        pokedexViewModel.pokedex.bind { [weak self] res in
            if res.count > 0 {
                self?.pokemons += res
            } else {
                self?.noMore = true
            }
        }
        
//        pokedexViewModel.statusCode.bind { [weak self] code in
//            print("Code: ",code)
//        }
    }
    
    @IBAction func onClickSearchButton(_ sender: Any) {
        print("Buscador: ",searchTextField.text)
    }
}

extension PokedexViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokedexCell") as! PokedexCell
        let data = pokemons[indexPath.row]
        cell.setupCell(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layoutSubviews()
        if indexPath.row == pokemons.count - 1 {
            isLoading = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            
            if offsetY > contentHeight - scrollView.frame.size.height, !isLoading, !noMore {
                isLoading = true
                pokedexViewModel.getCode()
            }
        }
    }
}

extension PokedexViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onClickSearchButton(UIButton())
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 50
    }
}
