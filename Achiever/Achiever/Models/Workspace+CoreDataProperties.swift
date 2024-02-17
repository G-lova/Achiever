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
    @NSManaged public var workspaceName: String?
    @NSManaged public var workspaceOwner: User?
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
