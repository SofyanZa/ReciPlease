//
//  CoreDataManager.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    /// FavoritesRecipesList est mon entité, on y fait la requete pour obtenir les données
    var favoritesRecipes: [FavoritesRecipesList] {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    // MARK: - Initializer
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }
    
    // MARK: - Methods
    
    func addRecipeToFavorites(name: String, image: Data, ingredientsDescription: [String], recipeUrl: String, time: String, yield: String) {
        let recipe = FavoritesRecipesList(context: managedObjectContext)
        recipe.image = image
        recipe.ingredients = ingredientsDescription
        recipe.name = name
        recipe.recipeUrl = recipeUrl
        recipe.totalTime = time
        recipe.yield = yield
        coreDataStack.saveContext()
    }
    
    func deleteRecipeFromFavorite(recipeName: String) {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", recipeName)
        request.predicate = predicate
        if let objects = try? managedObjectContext.fetch(request) {
            objects.forEach { managedObjectContext.delete($0)}
        }
        coreDataStack.saveContext()
    }
    
    func deleteAllFavorites() {
        favoritesRecipes.forEach { managedObjectContext.delete($0)}
        coreDataStack.saveContext()
    }
    
    func checkIfRecipeIsAlreadyFavorite(recipeName: String) -> Bool {
        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", recipeName)
        guard let recipes = try? managedObjectContext.fetch(request) else { return false }
        if recipes.isEmpty {return false}
        return true
    }
}

