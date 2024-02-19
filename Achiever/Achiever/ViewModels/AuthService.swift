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
}
