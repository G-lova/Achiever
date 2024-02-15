//
//  User+CoreDataProperties.swift
//  Achiever
//
//  Created by User on 15.02.2024.
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

}

extension User : Identifiable {

}
