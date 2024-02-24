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

    @NSManaged public var boardCreationDate: Date
    @NSManaged public var boardID: Int64
    @NSManaged public var boardName: String
    @NSManaged public var isArchive: Bool
    @NSManaged public var isPrivate: Bool
    @NSManaged public var boardOwner: User
    @NSManaged public var boardWorkspace: Workspace
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

extension Board {
    
    static func getAllBoards() -> NSFetchRequest<Board> {
        let request: NSFetchRequest<Board> = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "boardID", ascending: true)]
        return request
    }
    
    static func addNewBoard(boardName: String, boardOwner: User, boardWorkspace: Workspace) -> NSManagedObject {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let board = Board(context: context)
        let existedBoards = try? context.fetch(getAllBoards())
        if let boardWithMaxID = existedBoards?.last {
            if boardWithMaxID.boardID < UserDefaultsCounters.shared.boardCounter {
                board.boardID = UserDefaultsCounters.shared.boardCounter
            } else {
                board.boardID = boardWithMaxID.boardID + 1
            }
        }
        UserDefaultsCounters.shared.boardCounter = board.boardID
        board.boardName = boardName
        board.boardOwner = boardOwner
        board.boardWorkspace = boardWorkspace
        board.boardCreationDate = Date()
                
        CoreDataStack.shared.saveContext()
        
        AuthService.shared.currentBoard = board
        
        return board
    }
    
    static func loadDataFromCoreData(completion: @escaping (NSFetchedResultsController<Board>) -> Void) {
        let request = getAllBoards()
        let fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultController.performFetch()
            completion(fetchedResultController)
        } catch {
            print(error)
        }
    }
}
