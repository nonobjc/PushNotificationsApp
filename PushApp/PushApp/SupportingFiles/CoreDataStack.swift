//
//  CoreDataStack.swift
//  PushApp
//
//  Created by Alexander on 07/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let modelName = "PushNotifications"
    private lazy var storeContainer: NSPersistentContainer = {
        let groupName = "group.IBAction.PushApp"
        let url = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: groupName)!
            .appendingPathComponent("PushNotifications.sqlite")
        
        let container = NSPersistentContainer(name: modelName)
        
        container.persistentStoreDescriptions = [
            NSPersistentStoreDescription(url: url)
        ]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func removeObject(object: NSManagedObject) {
        managedContext.delete(object)
        saveContext()
    }
    
    func saveContext() {
        guard managedContext.hasChanges else {
            return
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
