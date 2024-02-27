//
//  UserActionsDelegate.swift
//  Achiever
//
//  Created by User on 15.02.2024.
//

import Foundation
import UIKit

protocol UserActionsDelegate {
    
    //MARK: - Authentification Actions Methods
    func didTapSignIn()
    func didTapSignUp()
    func didTapResetPassword()
    func didSendResetPasswordCode()
    
    //MARK: - Board Actions Methods
    func didTapCreateBoard()
    func didTapEditBoard(boardID: String)
    func didTapArchiveBoard(boardID: String)
    func didTapDeleteBoard(boardID: String)
    
    //MARK: - List Actions Methods
    func didTapCreateList()
    func didTapEditList(listID: String)
    func didTapArchiveList(listID: String)
    func didTapDeleteList(listID: String)
    func didTapReplaceList(listID: String)
    
    //MARK: - Task Actions Methods
    func didTapCreateTask()
    func didTapEditTask(taskID: String)
    func didTapArchiveList(taskID: String)
    func didTapDeleteList(taskID: String)
    func didTapReplaceList(taskID: String)
    
}
