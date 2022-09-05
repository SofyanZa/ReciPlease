//
//  RecipeService.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation

final class RecipeService {
    
    //MARK: - Properties
    
    private let session: AlamoSession
    
    //MARK: - Initializer
    
    init(session: AlamoSession = SearchSession()) {
        self.session = session
    }
    
    //MARK: - Method
    
    /// Method to send request with the API
    func getRecipes(ingredients: [String], callback: @escaping (Result<RecipesSearch, ErrorCases>) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiProfile.apiId)&app_key=\(ApiProfile.apiKey)") else { return }
        session.request(with: url) { responseData in
            guard let data = responseData.data else {
                print ("no data")
                callback(.failure(.errorNetwork))
                return
            }
            guard responseData.response?.statusCode == 200 else {
                print ("bad status code")
                callback(.failure(.invalidRequest))
                return
            }
            guard let responseJSON = try? JSONDecoder().decode(RecipesSearch.self, from: data) else {
                print ("no json")
                callback(.failure(.errorDecode))
                return
            }
            callback(.success(responseJSON))
        }
    }
}





