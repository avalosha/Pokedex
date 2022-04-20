//
//  PokedexCell.swift
//  Pokedex
//
//  Created by miniMAC Sferea on 19/04/22.
//

import UIKit

class PokedexCell: UITableViewCell {

    @IBOutlet weak var pokemonImage: CustomImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell(data: Pokemons) {
        nameLbl.text = data.name
        if let url = data.url {
            let index = getIndex(str: url)
            
            if let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png") {
                pokemonImage.downloaded(from: url, contentMode: .scaleAspectFill)
            }
        }
    }

    private func getIndex(str: String) -> String {
        let start = str.index(str.startIndex, offsetBy: 34)
        let end = str.index(str.endIndex, offsetBy: -1)
        let range = start..<end

        let mySubstring = str[range]
        return String(mySubstring)
    }
}
