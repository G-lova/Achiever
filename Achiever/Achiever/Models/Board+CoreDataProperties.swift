//
//  Board+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 15.02.2024.
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
    @NSManaged public var boardCreator: User?

}

extension Board : Identifiable {

}
