//
//  Task+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskID: Int64
    @NSManaged public var taskName: String?
    @NSManaged public var taskCreationDate: Date?
    @NSManaged public var taskDeadline: Date?
    @NSManaged public var isRepeat: Bool
    @NSManaged public var isFinished: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var needToRemind: Bool
    @NSManaged public var taskParentList: List?
    @NSManaged public var taskCreator: User?
    @NSManaged public var taskResponsibleUser: User?

}

extension Task : Identifiable {

}
