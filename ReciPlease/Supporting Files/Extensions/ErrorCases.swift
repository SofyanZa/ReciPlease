//
//  ErrorCases$.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation

//MARK: - Enumeration to manage errors

enum ErrorCases: Error {
    case invalidRequest
    case errorDecode
    case errorNetwork
}
