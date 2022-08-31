//
//  RecipeTableViewCell.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var InfosDiv: UIView!
    @IBOutlet weak var cornerInfos: UIView!
    
    // MARK: - Properties
    
    var recipe: Hit? {
        didSet {
            guard let recipe = recipe else { return }
            titleLabel.text = recipe.recipe.label
            totalTimeLabel.text = recipe.recipe.totalTime?.convertIntToTime
            if recipe.recipe.yield == 0 {
                yieldLabel.text = "NA"
            } else {
                yieldLabel.text = "\(recipe.recipe.yield ?? 0)"
            }
            ingredientLabel.text = recipe.recipe.ingredients[0].text
            guard let image = recipe.recipe.image else {return}
            guard let url = URL(string: image) else {return}
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.recipeImageView.image = UIImage(data: data! as Data)
                }
            }
        }
    }
    
    var favoriteRecipe: FavoritesRecipesList? {
        didSet {
            titleLabel.text = favoriteRecipe?.name
            guard let yield =  favoriteRecipe?.yield  else {return}
            if yield == "0" {
                yieldLabel.text = "NA"
            } else {
                yieldLabel.text = "\( yield)"
            }
            guard let ingredient = favoriteRecipe?.ingredients?.joined(separator: ",") else {return}
            ingredientLabel.text = "\(ingredient)"
            if let imageData = favoriteRecipe?.image {
                recipeImageView.image = UIImage(data: imageData)
            }
            totalTimeLabel.text = favoriteRecipe?.totalTime
        }
    }
    
}
