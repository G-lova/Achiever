//
//  User+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userEmail: String?
    @NSManaged public var userID: Int64
    @NSManaged public var userName: String?
    @NSManaged public var userPlan: String?
    @NSManaged public var uesrPassword: String?
    @NSManaged public var userWorkspaces: NSSet?
    @NSManaged public var userBoardsToOwn: NSSet?
    @NSManaged public var userTasksToExecute: NSSet?
    @NSManaged public var userBoardsToManage: NSSet?
    @NSManaged public var userBoardsToRead: NSSet?

}

// MARK: Generated accessors for userWorkspaces
extension User {

    @objc(addUserWorkspacesObject:)
    @NSManaged public func addToUserWorkspaces(_ value: Workspace)

    @objc(removeUserWorkspacesObject:)
    @NSManaged public func removeFromUserWorkspaces(_ value: Workspace)

    @objc(addUserWorkspaces:)
    @NSManaged public func addToUserWorkspaces(_ values: NSSet)

    @objc(removeUserWorkspaces:)
    @NSManaged public func removeFromUserWorkspaces(_ values: NSSet)

}

// MARK: Generated accessors for userBoardsToOwn
extension User {

    @objc(addUserBoardsToOwnObject:)
    @NSManaged public func addToUserBoardsToOwn(_ value: Board)

    @objc(removeUserBoardsToOwnObject:)
    @NSManaged public func removeFromUserBoardsToOwn(_ value: Board)

    @objc(addUserBoardsToOwn:)
    @NSManaged public func addToUserBoardsToOwn(_ values: NSSet)

    @objc(removeUserBoardsToOwn:)
    @NSManaged public func removeFromUserBoardsToOwn(_ values: NSSet)

}

// MARK: Generated accessors for userTasksToExecute
extension User {

    @objc(addUserTasksToExecuteObject:)
    @NSManaged public func addToUserTasksToExecute(_ value: Task)

    @objc(removeUserTasksToExecuteObject:)
    @NSManaged public func removeFromUserTasksToExecute(_ value: Task)

    @objc(addUserTasksToExecute:)
    @NSManaged public func addToUserTasksToExecute(_ values: NSSet)

    @objc(removeUserTasksToExecute:)
    @NSManaged public func removeFromUserTasksToExecute(_ values: NSSet)

}

// MARK: Generated accessors for userBoardsToManage
extension User {

    @objc(addUserBoardsToManageObject:)
    @NSManaged public func addToUserBoardsToManage(_ value: Board)

    @objc(removeUserBoardsToManageObject:)
    @NSManaged public func removeFromUserBoardsToManage(_ value: Board)

    @objc(addUserBoardsToManage:)
    @NSManaged public func addToUserBoardsToManage(_ values: NSSet)

    @objc(removeUserBoardsToManage:)
    @NSManaged public func removeFromUserBoardsToManage(_ values: NSSet)

}

// MARK: Generated accessors for userBoardsToRead
extension User {

    @objc(addUserBoardsToReadObject:)
    @NSManaged public func addToUserBoardsToRead(_ value: Board)

    @objc(removeUserBoardsToReadObject:)
    @NSManaged public func removeFromUserBoardsToRead(_ value: Board)

    @objc(addUserBoardsToRead:)
    @NSManaged public func addToUserBoardsToRead(_ values: NSSet)

    @objc(removeUserBoardsToRead:)
    @NSManaged public func removeFromUserBoardsToRead(_ values: NSSet)

}

extension User : Identifiable {

}
