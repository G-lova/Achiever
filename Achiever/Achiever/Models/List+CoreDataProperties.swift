//
//  List+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var listID: Int64
    @NSManaged public var listName: String?
    @NSManaged public var listCreationDate: Date?
    @NSManaged public var listParentBoard: Board?
    @NSManaged public var listCreator: User?

}

extension List : Identifiable {

}
