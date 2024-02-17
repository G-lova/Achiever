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

    @NSManaged public var listCreationDate: Date?
    @NSManaged public var listID: Int64
    @NSManaged public var listName: String?
    @NSManaged public var listParentBoard: Board?
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
