//
//  BoardViewModelDelegate.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

protocol BoardViewModelDelegate {
    func fetchBoards()
    func createBoard(boardID: String)
    
}
