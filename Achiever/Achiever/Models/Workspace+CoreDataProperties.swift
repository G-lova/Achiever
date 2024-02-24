//
//  Workspace+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension Workspace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workspace> {
        return NSFetchRequest<Workspace>(entityName: "Workspace")
    }

    @NSManaged public var workspaceID: Int64
    @NSManaged public var workspaceName: String
    @NSManaged public var workspaceOwner: User
    @NSManaged public var workspaceBoards: NSSet?

}

// MARK: Generated accessors for workspaceBoards
extension Workspace {

    @objc(addWorkspaceBoardsObject:)
    @NSManaged public func addToWorkspaceBoards(_ value: Board)

    @objc(removeWorkspaceBoardsObject:)
    @NSManaged public func removeFromWorkspaceBoards(_ value: Board)

    @objc(addWorkspaceBoards:)
    @NSManaged public func addToWorkspaceBoards(_ values: NSSet)

    @objc(removeWorkspaceBoards:)
    @NSManaged public func removeFromWorkspaceBoards(_ values: NSSet)

}

extension Workspace : Identifiable {

}

extension Workspace {
    
    static func getAllWorkspaces() -> NSFetchRequest<Workspace> {
        let request: NSFetchRequest<Workspace> = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "workspaceID", ascending: true)]
        return request
    }
    
    static func addNewWorkspace(workspaceName: String, workspaceOwner: User) -> NSManagedObject {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let workspace = Workspace(context: context)
        let existedWorkspaces = try? context.fetch(getAllWorkspaces())
        if let workspaceWithMaxID = existedWorkspaces?.last {
            if workspaceWithMaxID.workspaceID < UserDefaultsCounters.shared.workspaceCounter {
                workspace.workspaceID = UserDefaultsCounters.shared.workspaceCounter
            } else {
                workspace.workspaceID = workspaceWithMaxID.workspaceID + 1
            }
        }
        UserDefaultsCounters.shared.workspaceCounter = workspace.workspaceID
        workspace.workspaceName = workspaceName
        workspace.workspaceOwner = workspaceOwner
                
        CoreDataStack.shared.saveContext()
        
        AuthService.shared.currentWorkspace = workspace
        
        return workspace
    }
    
    static func loadDataFromCoreData(completion: @escaping (NSFetchedResultsController<Workspace>) -> Void) {
        let request = getAllWorkspaces()
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultController.performFetch()
            completion(fetchedResultController)
        } catch {
            print(error)
        }
    }
    
    
}
