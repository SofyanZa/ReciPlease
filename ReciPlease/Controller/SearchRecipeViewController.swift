//
//  SearchRecipeViewController.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

final class SearchRecipeViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties

    var ingredients: [String] = []
    let recipesService = RecipeService()
    var recipesSearch: RecipesSearch?
    let identifierSegue = "IngredientsToRecipes"
    
    //MARK: - Outlets
    
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak private var addIngredientButton: UIButton!
    @IBOutlet weak private var ingredientsTableView: UITableView!
    @IBOutlet weak private var searchRecipesButton: UIButton!
    @IBOutlet weak private var searchActivityController: UIActivityIndicatorView!
    @IBOutlet weak var fridgeDiv: UIView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: false)
        fridgeDiv.layer.borderWidth = 2
        fridgeDiv.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    // MARK: - Configure segue
    // Avertit le contrôleur de vue qu'une transition est sur le point d'être effectuée
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass data to next view
        if let recipesVC = segue.destination as? ListRecipeViewController {
            recipesVC.recipesSearch = recipesSearch
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapButtonToAddIngredient(_ sender: Any) {
        guard let ingredient = searchTextField.text, !ingredient.isBlank else { /// si texte est vide
            alert(message: "write an ingredient")
            return }
        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
        searchTextField.text = ""
    }
    
    @IBAction func didTapGoButton(_ sender: Any) { /// verify if one ingredient is added
        guard ingredients.count >= 1 else { return alert(message: "add an ingredient") }
        loadRecipes()     /// Request
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        let alertUserDelete = UIAlertController(title: "Delete All ?", message: "Are you sure you want to delete all ingredients ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.ingredients.removeAll()
            self.ingredientsTableView.reloadData()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        alertUserDelete.addAction(ok)
        alertUserDelete.addAction(cancel)
        present(alertUserDelete, animated: true, completion: nil)
    }
    
    /// Forgive keyboard on view
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    //MARK: - Methods
    

    /// Terminate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// Request
    func loadRecipes() {
        manageActivityIndicator(activityIndicator: searchActivityController, button: searchRecipesButton, showActivityIndicator: true)
        recipesService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let recipes):
                    self.recipesSearch = recipes
                    // Lance la séquence avec l'id spécifié.
                    self.performSegue(withIdentifier: self.identifierSegue, sender: nil)
                case .failure:
                    self.alert(message:"incorrect request")
                }
                self.manageActivityIndicator(activityIndicator: self.searchActivityController, button: self.searchRecipesButton, showActivityIndicator: false)
            }
        }
    }
}

//MARK: - Extension TableView

extension SearchRecipeViewController: UITableViewDataSource {
    
    /// configurer les lignes dans tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    /// configurer une cellule
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let ingredient = ingredients[indexPath.row]
        cell.configure(ingredient: ingredient)
        return cell
    }
    
    /// supprimer une ligne dans tableView
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
