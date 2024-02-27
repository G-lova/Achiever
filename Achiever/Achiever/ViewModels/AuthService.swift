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
    
    var isLoggedIn: Bool = false
    
    func logIn(userID: String) {
        isLoggedIn = true
        currentUser = userID
    }
    
    func logOut() {
        isLoggedIn = false
        currentUser = nil
    }
    
    var currentUser: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentUser") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentUser")
        }
    }
    
    var currentWorkspace: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentWorkspace") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentWorkspace")
        }
    }
    
    var currentBoard: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentBoard") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentBoard")
        }
    }
    
    var currentList: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentList") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentList")
        }
    }
    
    var currentTask: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentTask") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "currentTask")
        }
    }
}
