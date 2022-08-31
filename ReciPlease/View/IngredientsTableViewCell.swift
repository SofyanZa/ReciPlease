//
//  IngredientsTableViewCell.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Method to configure ingredient's cell
    func configure(ingredient: String) {
        ingredientLabel.text = "- \(ingredient)"
        ingredientLabel.textColor = .white
    }
}
