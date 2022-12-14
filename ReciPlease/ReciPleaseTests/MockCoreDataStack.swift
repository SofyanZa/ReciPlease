//
//  MockCoreDataStack.swift
//  ReciPleaseTests
//
//  Created by SofyanZ on 31/08/2022.
//

import ReciPlease
import Foundation
import CoreData

final class MockCoreDataStack: CoreDataStack {
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(modelName: "RecipeDataModel")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}

