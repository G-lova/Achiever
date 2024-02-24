//
//  AuthService.swift
//  Achiever
//
//  Created by User on 18.02.2024.
//

import UIKit
import  CoreData

class AuthService {
    static let shared = AuthService()
    
    var currentUser: User {
        get {
            return UserDefaults.standard.object(forKey: "currentUser") as! User
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentUser")
        }
    }
    
    var currentWorkspace: Workspace {
        get {
            return UserDefaults.standard.object(forKey: "currentWorkspace") as! Workspace
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentWorkspace")
        }
    }
    
    var currentBoard: Board {
        get {
            return UserDefaults.standard.object(forKey: "currentBoard") as! Board
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentBoard")
        }
    }
    
    var currentList: List {
        get {
            return UserDefaults.standard.object(forKey: "currentList") as! List
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentList")
        }
    }
    
    var currentTask: Task {
        get {
            return UserDefaults.standard.object(forKey: "currentTask") as! Task
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentTask")
        }
    }
    
//    func logOut() {
//        currentUser = nil
//    }
}
