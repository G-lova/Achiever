//
//  List+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var listCreationDate: Date
    @NSManaged public var listID: UUID
    @NSManaged public var listName: String
    @NSManaged public var listParentBoard: Board
    @NSManaged public var listTasks: NSSet?

}

// MARK: Generated accessors for listTasks
extension List {

    @objc(addListTasksObject:)
    @NSManaged public func addToListTasks(_ value: Task)

    @objc(removeListTasksObject:)
    @NSManaged public func removeFromListTasks(_ value: Task)

    @objc(addListTasks:)
    @NSManaged public func addToListTasks(_ values: NSSet)

    @objc(removeListTasks:)
    @NSManaged public func removeFromListTasks(_ values: NSSet)

}

extension List : Identifiable {

}

extension List {
    
    static func getAllLists() -> NSFetchRequest<List> {
        let request: NSFetchRequest<List> = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "listID", ascending: true)]
        return request
    }
    
    static func addNewList(listName: String, listParentBoard: Board) -> NSManagedObject {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let list = List(context: context)
        
        list.listID = UUID()
        list.listName = listName
        list.listParentBoard = listParentBoard
        list.listCreationDate = Date()
                
        CoreDataStack.shared.saveContext()
        
        return list
    }
    
    static func loadDataFromCoreData(completion: @escaping (NSFetchedResultsController<List>) -> Void) {
        let request = getAllLists()
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: "listName", cacheName: nil)
        do {
            try fetchedResultController.performFetch()
            completion(fetchedResultController)
        } catch {
            print(error)
        }
    }
}
