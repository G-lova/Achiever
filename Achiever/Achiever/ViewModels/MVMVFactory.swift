//
//  MVMVFactory.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

class MVVMFactory {
    
    func createBoardViewModel() -> BoardViewModelDelegate {
        return BoardViewModel.shared
    }
    
    func createListViewModel() -> ListViewModelDelegate {
        return ListViewModel.shared
    }
    
    func createTaskViewModel() -> TaskViewModelDelegate {
        return TaskViewModel.shared
    }
    
}
