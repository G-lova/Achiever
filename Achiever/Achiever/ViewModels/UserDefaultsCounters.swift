//
//  UserDefaultsCounters.swift
//  Achiever
//
//  Created by User on 21.02.2024.
//

import UIKit

class UserDefaultsCounters {
    
    static let shared = UserDefaultsCounters()
    
    var userCounter: Int64 {
        get {
            var counter = 1
            let storedCounter = UserDefaults.standard.integer(forKey: "userCounter")
            if storedCounter > 0 {
                counter = storedCounter + 1
            }
            return Int64(counter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userCounter")
        }
    }
    
    var workspaceCounter: Int64 {
        get {
            var counter = 1
            let storedCounter = UserDefaults.standard.integer(forKey: "workspaceCounter")
            if storedCounter > 0 {
                counter = storedCounter + 1
            }
            return Int64(counter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "workspaceCounter")
        }
    }
    
    var boardCounter: Int64 {
        get {
            var counter = 1
            let storedCounter = UserDefaults.standard.integer(forKey: "boardCounter")
            if storedCounter > 0 {
                counter = storedCounter + 1
            }
            return Int64(counter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "boardCounter")
        }
    }
    
    var listCounter: Int64 {
        get {
            var counter = 1
            let storedCounter = UserDefaults.standard.integer(forKey: "listCounter")
            if storedCounter > 0 {
                counter = storedCounter + 1
            }
            return Int64(counter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "listCounter")
        }
    }
    
    var taskCounter: Int64 {
        get {
            var counter = 1
            let storedCounter = UserDefaults.standard.integer(forKey: "taskCounter")
            if storedCounter > 0 {
                counter = storedCounter + 1
            }
            return Int64(counter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "taskCounter")
        }
    }
    
}
