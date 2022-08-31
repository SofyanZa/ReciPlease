//
//  ExtensionString.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation

//MARK: - Extension String

extension String {
    /// Vérifie si une chaîne contient au moins un élément
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }
}


