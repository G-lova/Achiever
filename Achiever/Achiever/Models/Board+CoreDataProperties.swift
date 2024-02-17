//
//  Board+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension Board {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board")
    }

    @NSManaged public var boardCreationDate: Date?
    @NSManaged public var boardID: Int64
    @NSManaged public var boardName: String?
    @NSManaged public var boardTheme: String?
    @NSManaged public var isArchive: Bool
    @NSManaged public var isPrivate: Bool
    @NSManaged public var boardOwner: User?
    @NSManaged public var boardWorkspace: Workspace?
    @NSManaged public var boardLists: NSSet?
    @NSManaged public var boardManagers: NSSet?
    @NSManaged public var boardReaders: NSSet?

}

// MARK: Generated accessors for boardLists
extension Board {

    @objc(addBoardListsObject:)
    @NSManaged public func addToBoardLists(_ value: List)

    @objc(removeBoardListsObject:)
    @NSManaged public func removeFromBoardLists(_ value: List)

    @objc(addBoardLists:)
    @NSManaged public func addToBoardLists(_ values: NSSet)

    @objc(removeBoardLists:)
    @NSManaged public func removeFromBoardLists(_ values: NSSet)

}

// MARK: Generated accessors for boardManagers
extension Board {

    @objc(addBoardManagersObject:)
    @NSManaged public func addToBoardManagers(_ value: User)

    @objc(removeBoardManagersObject:)
    @NSManaged public func removeFromBoardManagers(_ value: User)

    @objc(addBoardManagers:)
    @NSManaged public func addToBoardManagers(_ values: NSSet)

    @objc(removeBoardManagers:)
    @NSManaged public func removeFromBoardManagers(_ values: NSSet)

}

// MARK: Generated accessors for boardReaders
extension Board {

    @objc(addBoardReadersObject:)
    @NSManaged public func addToBoardReaders(_ value: User)

    @objc(removeBoardReadersObject:)
    @NSManaged public func removeFromBoardReaders(_ value: User)

    @objc(addBoardReaders:)
    @NSManaged public func addToBoardReaders(_ values: NSSet)

    @objc(removeBoardReaders:)
    @NSManaged public func removeFromBoardReaders(_ values: NSSet)

}

extension Board : Identifiable {

}
