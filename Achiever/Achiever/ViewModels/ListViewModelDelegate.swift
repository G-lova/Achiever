//
//  ListViewModelDelegate.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

protocol ListViewModelDelegate {
    func fetchLists()
    func createList(listName: String)
}
