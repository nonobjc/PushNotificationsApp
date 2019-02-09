//
//  MainViewController.swift
//  PushApp
//
//  Created by Alexander on 03/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    
    @IBOutlet private weak var mainImage: UIImageView!
    private var coreDataStack: CoreDataStack!
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        coreDataStack = appDelegate.coreDataStack
        let managedContext = coreDataStack.managedContext
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        do {
            messages = try managedContext.fetch(fetchRequest)
            print(messages.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

