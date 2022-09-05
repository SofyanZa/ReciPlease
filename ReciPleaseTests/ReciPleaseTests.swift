//
//  ReciPleaseTests.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//

import XCTest
@testable import ReciPlease

class RecipleaseTests: XCTestCase {
    
    /// test func getRecipes
    func testGetRecipes_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: [""]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // incorrect response passed
    func testGetRecipes_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        
        guard let url = URL(string: "https://api.edamam.com") else {
            XCTFail("wrong url")
            return
        }
        
        let responseKO = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        let session = FakeSession(fakeResponse: FakeResponse(response: responseKO, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    // undecodable data passed
    func testGetRecipes_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        
        guard let url = URL(string: "https://api.edamam.com") else {
            XCTFail("wrong url")
            return
        }
        
        let responseOK = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
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
        
        let responseOK = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let session = FakeSession(fakeResponse: FakeResponse(response: responseOK, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        requestService.getRecipes(ingredients: ["chicken"]) { result in
            guard case .success(let data) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertTrue(data.hits[0].recipe.label == "Chicken Vesuvio")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
