//
//  CoreDataStack.swift
//  ReciPlease
//
//  Created by SofyanZ on 31/08/2022.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    // MARK: - Property
    
    private let modelName: String
    
    // MARK: - Initializer
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack
    
    // encapsule l’instance de Core Data Stack
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error),\(error.userInfo)")
            }
        })
        return container
    }()
    
    // NSManagedObjectContext est une sorte de bloc-notes intelligent. Il réclame des objets au NSPersistentStoreCoordinator
    public lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    public func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
