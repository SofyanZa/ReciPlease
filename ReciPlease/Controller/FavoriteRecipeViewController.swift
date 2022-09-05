//
//  FavoriteRecipeViewController.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import UIKit

final class FavoriteRecipeViewController: UIViewController {
    
    
    //MARK: - Properties
    
    private var recipeDisplay: RecipeDisplay?
    private var coreDataManager: CoreDataManager?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var favoriteRecipeTableView: UITableView! { didSet { favoriteRecipeTableView.tableFooterView = UIView() }}
    @IBOutlet private var clearButton: UIBarButtonItem!
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        favoriteRecipeTableView.register(nibName, forCellReuseIdentifier: "recipeCell")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let coreDataStack = appDelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteRecipeTableView.reloadData()
    }
    
    //MARK: - Segue
    
    /// Segue to DetailsRecipeViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "FavoritesListToDetail" else {return}
        guard let recipesVc = segue.destination as? DetailRecipeViewController else {return}
        recipesVc.recipeDisplay = recipeDisplay
    }
    
    //MARK: - Action
    
    @IBAction private func didTapClearButton(_ sender: Any) {
        let alertUserDelete = UIAlertController(title: "Delete All ?", message: "Are you sure you want to delete all favorites ?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.coreDataManager?.deleteAllFavorites()
            self.favoriteRecipeTableView.reloadData()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        alertUserDelete.addAction(ok)
        alertUserDelete.addAction(cancel)
        present(alertUserDelete, animated: true, completion: nil)
        
        }
    }




//MARK: - TableView DataSource


extension FavoriteRecipeViewController: UITableViewDataSource {
    
    
    // configure number of lines in TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager?.favoritesRecipes.count ?? 0
    }
    // configurer un format de cellule dans tableView avec le fichier RecipeTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        cell.favoriteRecipe = coreDataManager?.favoritesRecipes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteRecipe = coreDataManager?.favoritesRecipes[indexPath.row]
        let recipeDisplay = RecipeDisplay(label: favoriteRecipe?.name ?? "", image: favoriteRecipe?.image, url: favoriteRecipe?.recipeUrl ?? "", ingredients: favoriteRecipe?.ingredients ?? [""], totalTime: favoriteRecipe?.totalTime, yield: favoriteRecipe?.yield)
        self.recipeDisplay = recipeDisplay
        performSegue(withIdentifier: "FavoritesListToDetail", sender: nil)
    }
}

//MARK: - TableView Delegate

extension FavoriteRecipeViewController: UITableViewDelegate {
    // hauteur de tableView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return coreDataManager?.favoritesRecipes.isEmpty ?? true ? tableView.bounds.size.height : 0
    }
    // hauteur de la cellule
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // demande à la source de données de vérifier que la ligne donnée est modifiable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // supprimer une recette favorite dans tableView
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let recipeName = coreDataManager?.favoritesRecipes[indexPath.row].name else {return}
        coreDataManager?.deleteRecipeFromFavorite(recipeName: recipeName)
        favoriteRecipeTableView.reloadData()
    }
    // animation de la cellule
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let translation = CATransform3DTranslate(CATransform3DIdentity,0,120,0)
        cell.layer.transform = translation
        cell.alpha = 0
        UIView.animate(withDuration: 0.75){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }
}
