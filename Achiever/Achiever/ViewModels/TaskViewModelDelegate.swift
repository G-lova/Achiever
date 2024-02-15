//
//  TaskViewModelDelegate.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

protocol TaskViewModelDelegate {
    func fetchTasks()
    func createTask(taskName: String)
    func markTaskAsDone(taskID: String)
}
