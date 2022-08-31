//
//  RecipeSession.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation
import Alamofire

//MARK: - Protocol AlamoSession and class SearchSession

protocol AlamoSession {
    func request(with url: URL, callBack: @escaping (AFDataResponse<Any>) -> Void)
}

final class SearchSession: AlamoSession {
    func request(with url: URL, callBack: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(url).responseJSON { responseData in
            callBack(responseData)
        }
    }
}
