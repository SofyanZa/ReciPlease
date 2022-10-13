//
//  ReciPleaseTests.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//

import XCTest
@testable import ReciPlease

class RecipleaseTests: XCTestCase {
    
    /// Test de la fonction get recipes et donc de la requête à l'api
    /// Quand aucune donnée n'est passée, cela devrait nous renvoyé une erreur
    func testGetRecipes_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        /// On crée une constante session, on lui assigne la Fausse Session qui prend en parametre la fause reponse
        let session = FakeSession(fakeResponse: FakeResponse(response: nil, data: nil))
        /// On crée une constante requestService qui contient une instance de la classe RecipeService
        let requestService = RecipeService(session: session)
        /// On crée une constante expectation pour realiser un test asynchrone on créer donc une instance de XCTestExpectation
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        /// Sur  la requeteService on vient tester la fonction getRecipes, qui s'occupe de faire la requete, en parametres elle prend des ingredients, on ne met rien car on veut tester le fait qu'aucune donnée n'est passée
        requestService.getRecipes(ingredients: [""]) { result in
            /// On utilise le guard pour gérer l'erreur
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            /// Doit nous retourner une erreur
            XCTAssertNotNil(error)
           /// Lorsque la tâche est terminée, on appele  fulfill sur expectation pour indiquer au test qu'il peut arrêter d'attendre et passer au test suivant.
            expectation.fulfill()
        }
        /// On Démarre la tâche asynchrone, puis on indique au test d'attendre que l'attente se termine dans un laps de temps que nous spécifions.
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Quand une reponse incorecte est reçue
    func testGetRecipes_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        
        /// On gère l'url avec un guard let pour eviter de forcer le débalage!
        guard let url = URL(string: "https://api.edamam.com") else {
            XCTFail("wrong url")
            return
        }
        
        /// On instance une mauvaise réponse ( 500 ) que l'on stock dans une constante
        let responseKO = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        /// On instancie une fausse session avec en parametre une fausse reponse incorrecte et une donnée correcte tirée de notre fake response data
        let session = FakeSession(fakeResponse: FakeResponse(response: responseKO, data: FakeResponseData.correctData))
        /// On crée une instance de RecipeService
        let requestService = RecipeService(session: session)
        /// On crée une constante expectation pour realiser un test asynchrone on créer donc une instance de XCTestExpectation
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        /// On vient tester la fonction get recipes avec un ingrédient aléatoire
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            /// On gère l'erreur avec un guard
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            /// Cela devrait nous renvoyer une erreur
            XCTAssertNotNil(error)
            /// Lorsque la tâche est terminée, on appele  fulfill sur expectation pour indiquer au test qu'il peut arrêter d'attendre et passer au test suivant.
            expectation.fulfill()
        }
        /// On Démarre la tâche asynchrone, puis on indique au test d'attendre que l'attente se termine dans un laps de temps que nous spécifions.
        wait(for: [expectation], timeout: 0.01)
    }
    // Quand une donnée indécodable est reçue, devrait nous renvoyer une erreur
    func testGetRecipes_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        
        /// On créer une fausse url
        guard let url = URL(string: "https://api.edamam.com") else {
            XCTFail("wrong url")
            return
        }
        
        /// Création d'une bonne réponse (status 200 )
        let responseOK = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        /// Bonne réponse mais donnée incorrecte
        let session = FakeSession(fakeResponse: FakeResponse(response: responseOK, data: FakeResponseData.incorrectData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // correct data success
    func testGetRecipes_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        
        guard let url = URL(string: "https://api.edamam.com") else {
            XCTFail("right url")
            return
        }
        /// Bonne reponse du serveur
        let responseOK = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        /// On passe en parametre la fake reponse avec la reponse OK que l'on vient de créer, et une donnée correct
        let session = FakeSession(fakeResponse: FakeResponse(response: responseOK, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            /// On gère le succes avec le guard
            guard case .success(let data) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            /// Retourne une booléen , doit retourner le nom exact de la première donnée reçue
            XCTAssertTrue(data.hits[0].recipe.label == "Chicken Vesuvio")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
