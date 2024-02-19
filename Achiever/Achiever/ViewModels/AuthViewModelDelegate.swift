//
//  AuthViewModelDelegate.swift
//  Achiever
//
//  Created by User on 18.02.2024.
//

import UIKit

protocol AuthViewModelDelegate {
    
    func signIn(email: String, password: String)
    func sendResetCode(email: String, completion: @escaping (String) -> Void)
    func updatePassword(email: String, newPassword: String)
}
