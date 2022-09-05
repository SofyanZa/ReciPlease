//
//  DetailRecipeViewController.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

class DetailRecipeViewController: UIViewController {
    
    //MARK: - Properties
    
    var recipeDisplay: RecipeDisplay?
    var coreDataManager: CoreDataManager?
    
    //MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var goDirectionButton: UIButton!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var goActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ingredientDetailTableView: UITableView!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
        updateTheView()
        recipeImageView.layer.borderWidth = 2
        recipeImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTheFavoriteIcon()
        
    }
}

// MARK: - Method

extension DetailRecipeViewController {
    
    /// mettre à jour la vue
    private func updateTheView() {
        recipeTitleLabel.text = recipeDisplay?.label
        recipeImageView.image = UIImage(data: recipeDisplay?.image ?? Data())
        yieldLabel.text = recipeDisplay?.yield
        totalTimeLabel.text = recipeDisplay?.totalTime
    }
}

// MARK: - CoreData

extension DetailRecipeViewController {
    
    private func updateTheFavoriteIcon(){
        guard coreDataManager?.checkIfRecipeIsAlreadyFavorite(recipeName: recipeTitleLabel.text ?? "") == true else {
            favoriteButton.image = UIImage(named: "empty_heart")
            return }
        favoriteButton.image = UIImage(named: "full_heart")
    }
    
    private func addRecipeToFavorites() {
        guard let name = recipeDisplay?.label, let image = recipeDisplay?.image, let ingredients = recipeDisplay?.ingredients, let url = recipeDisplay?.url, let time = recipeDisplay?.totalTime, let yield = recipeDisplay?.yield else {return}
        coreDataManager?.addRecipeToFavorites(name: name, image: image, ingredientsDescription: ingredients, recipeUrl: url, time: time, yield: yield)
        
    }
}

// MARK: - Actions

extension DetailRecipeViewController {
    
    @IBAction private func didTapGetDirectionsButton(_ sender: Any) {
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: true)
        guard let directionsUrl = URL(string: recipeDisplay?.url ?? "") else {return}
        UIApplication.shared.open(directionsUrl)
        manageActivityIndicator(activityIndicator: goActivityIndicator, button: goDirectionButton, showActivityIndicator: false)
    }
    

    
    /// action lorsque l'icône favorite a été tapée
    @IBAction private func didTapFavoriteButton(_ sender: UIBarButtonItem) {
        // lorsque la recette n'est pas dans la liste des favoris pour l'ajouter, alerter l'utilisateur
        if sender.image == UIImage(named: "empty_heart") {
            sender.image = UIImage(named: "full_heart")
            alert(message: "Recipe added to your favorites list")
            addRecipeToFavorites()
            // lorsque la recette est déjà ajoutée dans la liste des favoris pour la supprimer, alerter l'utilisateur
        } else if sender.image == UIImage(named: "full_heart") {
            sender.image = UIImage(named: "empty_heart")
            alert(message: "Recipe deleted from your favorites list")
            coreDataManager?.deleteRecipeFromFavorite(recipeName: recipeDisplay?.label ?? "")
        }
    }
}

//MARK: - TableViewDataSource

extension DetailRecipeViewController: UITableViewDataSource {
    // configure number of lines in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDisplay?.ingredients.count ?? 0
    }
    // configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipeDisplay = recipeDisplay else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailCell", for: indexPath)
        let ingredient = recipeDisplay.ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        return cell
    }
}




