//
//  Task+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var isFinished: Bool
    @NSManaged public var isRepeat: Bool
    @NSManaged public var needToRemind: Bool
    @NSManaged public var taskCreationDate: Date
    @NSManaged public var taskDeadline: Date?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskID: Int64
    @NSManaged public var taskName: String
    @NSManaged public var taskParentList: List
    @NSManaged public var taskExecutor: NSSet?
    @NSManaged public var taskFiles: NSSet?

}

// MARK: Generated accessors for taskExecutor
extension Task {

    @objc(addTaskExecutorObject:)
    @NSManaged public func addToTaskExecutor(_ value: User)

    @objc(removeTaskExecutorObject:)
    @NSManaged public func removeFromTaskExecutor(_ value: User)

    @objc(addTaskExecutor:)
    @NSManaged public func addToTaskExecutor(_ values: NSSet)

    @objc(removeTaskExecutor:)
    @NSManaged public func removeFromTaskExecutor(_ values: NSSet)

}

// MARK: Generated accessors for taskFiles
extension Task {

    @objc(addTaskFilesObject:)
    @NSManaged public func addToTaskFiles(_ value: Files)

    @objc(removeTaskFilesObject:)
    @NSManaged public func removeFromTaskFiles(_ value: Files)

    @objc(addTaskFiles:)
    @NSManaged public func addToTaskFiles(_ values: NSSet)

    @objc(removeTaskFiles:)
    @NSManaged public func removeFromTaskFiles(_ values: NSSet)

}

extension Task : Identifiable {

}

extension Task {
    
    static func getAllTasks() -> NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "taskID", ascending: true)]
        return request
    }
    
    static func addNewTask(taskName: String, taskParentList: List) -> NSManagedObject {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let task = Task(context: context)
        let existedTasks = try? context.fetch(getAllTasks())
        if let taskWithMaxID = existedTasks?.last {
            if taskWithMaxID.taskID < UserDefaultsCounters.shared.taskCounter {
                task.taskID = UserDefaultsCounters.shared.taskCounter
            } else {
                task.taskID = taskWithMaxID.taskID + 1
            }
        }
        UserDefaultsCounters.shared.taskCounter = task.taskID
        task.taskName = taskName
        task.taskParentList = taskParentList
        task.taskCreationDate = Date()
                
        CoreDataStack.shared.saveContext()
        
        AuthService.shared.currentTask = task
        
        return task
    }
    
    static func loadDataFromCoreData(completion: @escaping (NSFetchedResultsController<Task>) -> Void) {
        let request = getAllTasks()
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultController.performFetch()
            completion(fetchedResultController)
        } catch {
            print(error)
        }
    }
}
