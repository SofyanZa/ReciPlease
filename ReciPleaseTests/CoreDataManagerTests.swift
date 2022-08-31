//
//  CoreDataManagerTests.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//


@testable import ReciPlease
import XCTest

final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Variables
    
    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests
    
    // test save recipe
    func testAddRecipeToFavoritesMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        XCTAssertTrue(!coreDataManager.favoritesRecipes.isEmpty)
        XCTAssertTrue(coreDataManager.favoritesRecipes.count == 1)
        XCTAssertTrue(coreDataManager.favoritesRecipes[0].name! == "Chicken Vesuvio")
    }
    // test delete all recipes
    func testDeleteAllRecipesMethod_WhenEntitiesAreDeleted_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        coreDataManager.deleteAllFavorites()
        XCTAssertTrue(coreDataManager.favoritesRecipes.isEmpty)
    }
    
    // test delete one recipe
    func testDeleteOneRecipeMethod_WhenEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        coreDataManager.addRecipeToFavorites(name: "Strong Cheese", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        coreDataManager.deleteRecipeFromFavorite(recipeName: "Chicken Vesuvio")
        XCTAssertTrue(!coreDataManager.favoritesRecipes.isEmpty)
        XCTAssertTrue(coreDataManager.favoritesRecipes.count == 1)
        XCTAssertTrue(coreDataManager.favoritesRecipes[0].name! == "Strong Cheese")
    }
    
    // test if recipe is already saved
    func testCheckingIfRecipeIsAlreadyFavorite_WhenFuncIsCalling_ThenShouldReturnTrue() {
        coreDataManager.addRecipeToFavorites(name: "Chicken Vesuvio", image: Data(), ingredientsDescription: [""], recipeUrl: "http://www.recipes.com/recipes/8793/", time: "", yield: "")
        XCTAssertTrue(coreDataManager.checkIfRecipeIsAlreadyFavorite(recipeName: "Chicken Vesuvio"))
    }
}
