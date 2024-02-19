//
//  AuthViewModel.swift
//  Achiever
//
//  Created by User on 18.02.2024.
//

import UIKit
import MessageUI
import CoreData

class AuthViewModel: AuthViewModelDelegate {
        
    static let shared = AuthViewModel()
    
    private init() {}
    
    // Authentification process
    func signIn(email: String, password: String) {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let users = try? context.fetch(User.getAllUsers())
        if let users = users {
            for user in users {
                if user.userEmail == email && user.userPassword == password {
                    AuthService.shared.currentUser = user
                    return
                }
            }
            print("Неверный пароль")
        } else {
            print("Неверный пароль")
        }
    }
    
    func sendResetCode(email: String, completion: @escaping (String) -> Void) {
        
        let code = generateRandomCode()
        completion(code)
    }
    
    func updatePassword(email: String, newPassword: String) {
        // обновление пароля в Core Data
    }
    
    func generateRandomCode() -> String {
        let allowedCharacters = "0123456789"
        var randomeCode = ""
        
        for _ in 0 ..< 6 {
            let randomIndex = Int(arc4random_uniform(UInt32(allowedCharacters.count)))
            let character = allowedCharacters[allowedCharacters.index(allowedCharacters.startIndex, offsetBy:randomIndex)]
            randomeCode += String(character)
        }
        return randomeCode
    }
}
