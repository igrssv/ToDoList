//
//  DataManager.swift
//  ToDoList
//
//  Created by Игорь Сысоев on 01.11.2021.
//

import Foundation
import CoreData


class StorageManager {
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
//MARK: - Fetch
    func fetchData(completion: (Result <[Task], Error>) -> Void) {
        let fetchReqest = Task.fetchRequest()
        do {
            let tasks = try viewContext.fetch(fetchReqest)
            completion(.success(tasks))
        } catch let error{
            completion(.failure(error))
        }
    }
    
//MARK: - Save
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.titel = taskName
        completion(task)
        saveContext()
        
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
        
    }
    
    func edit(_ task: Task, newName: String) {
        task.titel = newName
        saveContext()
    }
    
    
    
    
}
