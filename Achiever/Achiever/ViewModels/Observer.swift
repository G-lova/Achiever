//
//  Observer.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

class Observer {
    
    var boardViewModel: BoardViewModelDelegate
    var listViewModel: ListViewModelDelegate
    var taskViewModel: TaskViewModelDelegate
    
    init(boardViewModel: BoardViewModelDelegate, listViewModel: ListViewModelDelegate, taskViewModel: TaskViewModelDelegate) {
        self.boardViewModel = boardViewModel
        self.listViewModel = listViewModel
        self.taskViewModel = taskViewModel
    }
    
    func startObserving() {
        
    }
}
