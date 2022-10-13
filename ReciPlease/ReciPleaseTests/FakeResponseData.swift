//
//  FakeResponseData.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation

final class FakeResponseData {
    
    class NetworkError: Error {}
    static let networkError = NetworkError()
    
    static var correctData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "EdamamRecipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}

