//
//  Files+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 16.02.2024.
//
//

import Foundation
import CoreData


extension Files {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Files> {
        return NSFetchRequest<Files>(entityName: "Files")
    }

    @NSManaged public var fileData: Data?
    @NSManaged public var fileID: Int64
    @NSManaged public var fileName: String?
    @NSManaged public var fileTask: Task?

}

extension Files : Identifiable {

}
