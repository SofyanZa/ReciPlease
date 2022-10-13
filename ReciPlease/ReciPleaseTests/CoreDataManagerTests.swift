//
//  CoreDataManagerTests.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//


@testable import ReciPlease
import XCTest

/// Test de la classe Core Data Manager
final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Variables
    
    /// Création d'une variable coreDataStack qui contient une instance déballée de MockCoreDataStack
    var coreDataStack: MockCoreDataStack!
    /// Création d'une variable coreDataManager qui contient une instance de la classe CoreDataMananger
    var coreDataManager: CoreDataManager!
    
    // MARK: - Tests Life Cycle
    
    /// Cette méthode est appelée avant chaque invocation de chaque méthode de test écrit dans la classe
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    /// Cette méthode est appelée après l’invocation de chaque méthode de tests écrits dans la classe
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests
    
    // Test d'ajout d'une recette aux favoris
    func testAddRecipeToFavoritesMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        /// Sur la variable coreDataManger on selectionne la fonction d'ajout d'une recette aux favoris
        /// En argument, le nom de la recette,  une image associée, la description, l'url de la recette, le temps de preparation et le nombre de couverts
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        /// On verifie ensuite si, de base le coredatamanager est vide
        XCTAssertTrue(!coreDataManager.favoritesRecipes.isEmpty)
        /// Puis on verifie qu'il passe à 1
        XCTAssertTrue(coreDataManager.favoritesRecipes.count == 1)
        /// Et que son nil est bien celui recu
        XCTAssertTrue(coreDataManager.favoritesRecipes[0].name! == "Chicken Vesuvio")
    }
    
    // Test de supression d'une recette des favoris
    func testDeleteOneRecipeMethod_WhenEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
        /// Pour commencer on ajoute une recette
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        /// Puis une deuxieme
        coreDataManager.addRecipeToFavorites(name: "Strong Cheese", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        /// Puis on suprime la premiere recette
        coreDataManager.deleteRecipeFromFavorite(recipeName: "Chicken Vesuvio")
        /// On verifie si l'objet est vide
        XCTAssertTrue(!coreDataManager.favoritesRecipes.isEmpty)
        /// Le nombre de recette doit être egal à 1
        XCTAssertTrue(coreDataManager.favoritesRecipes.count == 1)
        /// Son nom doit être le deuxiem favoris rajouté
        XCTAssertTrue(coreDataManager.favoritesRecipes[0].name! == "Strong Cheese")
    }
    
    // Test si la fonction de suppression de tous les favoris fonctionne
    func testDeleteAllRecipesMethod_WhenEntitiesAreDeleted_ThenShouldBeCorrectlyDeleted() {
        /// On ajoutee une recette aux favoris
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        /// On supprime grâce à la méthode crée dans le coredata manager, deleteAllFavorites
        coreDataManager.deleteAllFavorites()
        /// On test si l'objet est vide
        XCTAssertTrue(coreDataManager.favoritesRecipes.isEmpty)
    }
    
    
    // Test si une recette est deja favorites
    func testCheckingIfRecipeIsAlreadyFavorite_WhenFuncIsCalling_ThenShouldReturnTrue() {
        /// On ajoute une recette aux favoris
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        /// On verifie grâce à la méthode checkIfRecipeIsAlreadyFavorite si le nom correspond bien
        XCTAssertTrue(coreDataManager.checkIfRecipeIsAlreadyFavorite(recipeName: "Chicken Vesuvio"))
    }
}
